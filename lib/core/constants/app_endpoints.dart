/// All API base URLs and endpoint paths for JigroPay.
///
/// Usage: `AppEndpoints.baseUrl + AppEndpoints.login`
/// or just `AppEndpoints.login` when [ApiClient] already has [baseUrl] set.
abstract final class AppEndpoints {
  // ── Base ────────────────────────────────────────────────────────────────────
  static const String host = 'https://bbps.jigropay.com/';
  static const String baseUrl = '${host}api/';

  // ── Auth ────────────────────────────────────────────────────────────────────
  static const String partnerStream = 'stream';
  static const String register = 'auth/register';
  static const String sendOtp = 'auth/send-otp';
  static const String verifyOtp = 'auth/verify-otp';
  static const String profile = 'auth/profile';
  static const String updateProfile = 'auth/profile/update';
  static const String logout = 'auth/logout';

  // ── Content ─────────────────────────────────────────────────────────────────
  static const String banners = 'banners';
  static const String cms = 'cms/'; // append slug e.g. cms/privacy-policy
  static const String transactionHistory = 'auth/transaction-history';
  static const String helpEnquiries = 'auth/enquiries';
  static const String faqs = 'faqs';

  // ── Notifications ────────────────────────────────────────────────────────────
  static const String notifications = 'auth/notifications';
  static const String fetchUnreadNotifications =
      'auth/notifications/fetch-unread';
  static const String markAllReadNotifications =
      'auth/notifications/mark-all-read';
  static const String clearAllNotifications = 'auth/notifications/clear-all';

  // ── Recharge ─────────────────────────────────────────────────────────────────
  static const String operatorFetch = 'inspay/operator/fetch';
  static const String rechargePlans = 'inspay/recharge/plans';
  static const String dthOperatorFetch = 'fetch/dth/operators';
  static const String dthRechargePlans = 'ekyc/fetch/dth/plan';
  static const String rOffer = 'ekyc/fetch/roffer';

  /// Append service-type slug: e.g. [operatorsByType] + 'water'
  static const String operatorsByType = 'ekyc/operators/';

  // ── Bill Payments ─────────────────────────────────────────────────────────────
  static const String fastagBillFetch = 'ekyc/fetch/fastag_bill';
  static const String utilityBillFetch = 'ekyc/fetch/bill';
  static const String creditCardBillFetch = 'inspay/credit_card/bill_fetch';

  // ── PAN / Misc ────────────────────────────────────────────────────────────────
  static const String nsdlNewPan = 'ekyc/verify/pan_redirection';

  // ── Payment ───────────────────────────────────────────────────────────────────
  static const String createOrder = 'inspay/recharge/create-order';
  static const String verifyPayment = 'inspay/recharge/verify';
  static const String recentRecharges = 'inspay/recharge/latest';
}
