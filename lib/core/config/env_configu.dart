import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class EnvConfig {
  static String get razorpayLiveKey {
    final key = dotenv.env['RAZORPAY_KEY_LIVE'];
    if (key == null) {
      throw Exception('RAZORPAY_KEY_LIVE not found in .env file');
    }
    return key;
  }

  static String get razorpayTestKey {
    final key = dotenv.env['RAZORPAY_KEY_TEST'];
    if (key == null) {
      throw Exception('RAZORPAY_KEY_TEST not found in .env file');
    }
    return key;
  }
}
