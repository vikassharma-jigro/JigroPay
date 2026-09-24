import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/app_endpoints.dart';
import '../errors/exceptions.dart';
import '../services/storage_service.dart';
import '../utils/api_message_cleaner.dart';

/// Central Dio HTTP client for JigroPay.
///
/// Key design decisions:
/// - **No [BuildContext]** in any method — loading/error state is the Cubit's job.
/// - **No [Get.dialog]** — eliminated entirely.
/// - Auto-injects `Authorization: Bearer <token>` via [InterceptorsWrapper].
/// - On `401` → adds to [unauthorizedStream]; [app.dart] listens and triggers logout.
/// - Returns raw [Response] to callers; repositories interpret the status codes.
/// - [cleanApiMessage] is now in its own util, not embedded here.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  // ── 401 Auto-logout stream ────────────────────────────────────────────────────
  final _unauthorizedController = StreamController<void>.broadcast();

  /// Listen to this stream in [app.dart] to trigger global logout on 401.
  Stream<void> get unauthorizedStream => _unauthorizedController.stream;

  // ── Dio instance ──────────────────────────────────────────────────────────────
  late final Dio _dio = _buildDio();

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // Let all status codes through — we inspect them ourselves.
        validateStatus: (status) => status != null && status < 600,
      ),
    );

    // Auth token interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.instance.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401) {
            _unauthorizedController.add(null);
          }
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );

    // Pretty logger in debug only
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    return dio;
  }

  // ── Public HTTP methods ───────────────────────────────────────────────────────

  /// HTTP GET.
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _assertConnected();
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// HTTP POST with JSON body.
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    await _assertConnected();
    try {
      return await _dio.post(
        path,
        data: data ?? {},
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// HTTP POST with multipart form data (file uploads).
  Future<Response> postMultipart(
    String path, {
    required Map<String, String> fields,
    String? fileKey,
    String? filePath,
    Options? options,
  }) async {
    await _assertConnected();
    try {
      final formMap = <String, dynamic>{...fields};
      if (fileKey != null &&
          filePath != null &&
          filePath.isNotEmpty &&
          !filePath.startsWith('http')) {
        formMap[fileKey] = await MultipartFile.fromFile(filePath);
      }
      final formData = FormData.fromMap(formMap);

      final token = await StorageService.instance.getAccessToken();
      return await _dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (s) => s != null && s < 600,
        ),
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// HTTP PUT.
  Future<Response> put(
    String path, {
    dynamic data,
    Options? options,
  }) async {
    await _assertConnected();
    try {
      return await _dio.put(path, data: data ?? {}, options: options);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  /// HTTP DELETE.
  Future<Response> delete(
    String path, {
    Options? options,
  }) async {
    await _assertConnected();
    try {
      return await _dio.delete(path, options: options);
    } on DioException catch (e) {
      throw _mapDioException(e);
    } on SocketException {
      throw const NetworkException();
    }
  }

  // ── Response inspection helpers ───────────────────────────────────────────────

  /// Throws [ServerException] for non-2xx / API-failure responses.
  /// Call this in repositories after receiving a [Response].
  void throwIfError(Response response) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode == 401) {
      _unauthorizedController.add(null);
      throw const UnauthorizedException();
    }

    if (statusCode >= 400) {
      final msg = cleanApiMessage(response.data);
      throw ServerException(
        message: msg.isNotEmpty ? msg : 'Server error occurred.',
        statusCode: statusCode,
      );
    }

    // Check application-level failure flag (status: false)
    if (response.data is Map) {
      final status = response.data['status'];
      if (status == false || status == 'false' || status == 0 || status == 'Failure') {
        final msg = cleanApiMessage(response.data);
        throw ServerException(
          message: msg.isNotEmpty ? msg : 'Request failed.',
          statusCode: statusCode,
        );
      }
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────────

  Future<void> _assertConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw const NetworkException();
      }
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException();
    }
  }

  AppException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        if (statusCode == 401) {
          _unauthorizedController.add(null);
          return const UnauthorizedException();
        }
        final msg = cleanApiMessage(e.response?.data);
        return ServerException(
          message: msg.isNotEmpty ? msg : 'Server error occurred.',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');
      default:
        if (e.error is SocketException) return const NetworkException();
        return ServerException(
          message: e.message ?? 'Unknown error occurred.',
          statusCode: 0,
        );
    }
  }

  void dispose() => _unauthorizedController.close();
}
