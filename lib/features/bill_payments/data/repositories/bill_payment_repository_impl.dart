import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../recharge/data/models/order_model.dart';
import '../../domain/repositories/bill_payment_repository.dart';
import '../models/bill_details_model.dart';
import '../models/biller_model.dart';

class BillPaymentRepositoryImpl implements BillPaymentRepository {
  BillPaymentRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<List<BillerModel>>> fetchBillersByType({
    required String serviceType,
  }) async {
    try {
      final normalizedType =
          serviceType == 'municipal' ? 'municipal_taxes' : serviceType;
      final response = await _apiClient.get(
        '${AppEndpoints.operatorsByType}$normalizedType',
      );

      final data = response.data;
      List rawList = [];
      if (data is Map<String, dynamic>) {
        rawList = data['data'] as List? ??
            data['operators'] as List? ??
            data['billers'] as List? ??
            [];
      } else if (data is List) {
        rawList = data;
      }

      final billers = rawList
          .whereType<Map<String, dynamic>>()
          .map(BillerModel.fromJson)
          .where((b) => b.name.isNotEmpty)
          .toList();

      return Success(billers);
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<BillDetailsModel>> fetchBillDetails({
    required String serviceType,
    required String billerCode,
    required String consumerNumber,
    Map<String, dynamic>? extraFields,
  }) async {
    try {
      String endpoint;
      Map<String, dynamic> body;

      final normType = serviceType.toLowerCase().replaceAll('-', '_');
      if (normType == 'fastag') {
        endpoint = AppEndpoints.fastagBillFetch;
        body = {
          'consumer_id': consumerNumber,
          'opcode': billerCode,
        };
      } else if (normType == 'credit_card') {
        endpoint = AppEndpoints.creditCardBillFetch;
        body = {
          'card': consumerNumber,
          'opcode': billerCode,
          'mobile': extraFields?['mobile']?.toString() ?? '',
        };
      } else {
        endpoint = AppEndpoints.utilityBillFetch;
        body = {
          'consumer_id': consumerNumber,
          'opcode': billerCode,
        };
      }

      if (extraFields != null && extraFields.isNotEmpty) {
        body.addAll(extraFields);
      }

      final response = await _apiClient.post(endpoint, data: body);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final bill = BillDetailsModel.fromJson(data);
        return Success(bill);
      }
      return const Error(ServerFailure('Failed to fetch bill details'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderModel>> createBillOrder({
    required String opcode,
    required String consumerNumber,
    required double amount,
    required String fetchId,
    String? serviceType,
  }) async {
    try {
      final body = {
        'opcode': opcode,
        'number': consumerNumber,
        'amount': amount.toString(),
        'fetch_id': fetchId,
        if (serviceType != null && serviceType.isNotEmpty) 'type': serviceType,
      };

      final response = await _apiClient.post(
        AppEndpoints.createOrder,
        data: body,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final order = OrderModel.fromJson(data);
        return Success(order);
      }
      return const Error(ServerFailure('Invalid bill order response'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaymentVerifyModel>> verifyBillPayment({
    required String paymentId,
    required String orderId,
    required String signature,
    String? serviceType,
  }) async {
    try {
      final body = {
        'razorpay_payment_id': paymentId,
        'razorpay_order_id': orderId,
        'razorpay_signature': signature,
        if (serviceType != null && serviceType.isNotEmpty) 'type': serviceType,
      };

      final response = await _apiClient.post(
        AppEndpoints.verifyPayment,
        data: body,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final verifyResult = PaymentVerifyModel.fromJson(data);
        return Success(verifyResult);
      }
      return const Error(ServerFailure('Invalid bill payment verification'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
