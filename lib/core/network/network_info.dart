import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Network connectivity checker — no GetX dependency.
///
/// Migrated from [ConnectionStatus] in `app_utils/connectivity.dart`.
/// Uses actual DNS lookup to verify real internet access (not just radio status).
class NetworkInfo {
  NetworkInfo._();
  static final NetworkInfo instance = NetworkInfo._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  bool _hasConnection = true;

  /// Stream that emits `true`/`false` whenever connectivity changes.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Most recently known connection status (may be slightly stale).
  bool get isConnectedSync => _hasConnection;

  /// Initialize connectivity listener. Call once from [NotificationService.initialize].
  void init() {
    _connectivity.onConnectivityChanged.listen((results) {
      final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      if (result == ConnectivityResult.none) {
        _hasConnection = false;
        _controller.add(false);
      } else {
        // Confirm actual internet, not just radio
        checkConnection();
      }
    });
  }

  /// Performs a real DNS lookup to verify internet access.
  /// Returns `true` if connected.
  Future<bool> checkConnection() async {
    final previous = _hasConnection;
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      _hasConnection = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      _hasConnection = false;
    } on TimeoutException {
      _hasConnection = false;
    } catch (e) {
      debugPrint('[NetworkInfo] checkConnection error: $e');
      _hasConnection = false;
    }

    if (previous != _hasConnection) {
      _controller.add(_hasConnection);
    }
    return _hasConnection;
  }

  void dispose() => _controller.close();
}
