const String IP = 'http://157.20.51.180:8001/';
const String ImagePath = '';
const String BASE_URL = IP + 'api/';

// APIs url users
const String partnerSignupUrl = 'stream';
const String registerUrl = 'auth/register';
const String loginUrl = 'auth/send-otp';
const String verifyOtpUrl = 'auth/verify-otp';
const String profileUrl = 'auth/profile';
const String updateProfileUrl = 'auth/profile/update';
const String logoutUrl = 'auth/logout';
const String bannersUrl = 'banners';
const String cmsUrl = 'cms/';
const String transactionHistoryUrl = 'auth/transaction-history';
const String helpEnquiriesUrl = 'auth/enquiries';
const String faqsUrl = 'faqs';

// Notification APIs
const String notificationsUrl = 'auth/notifications';
const String fetchUnreadNotificationsUrl = 'auth/notifications/fetch-unread';
const String markAllReadNotificationsUrl = 'auth/notifications/mark-all-read';
const String clearAllNotificationsUrl = 'auth/notifications/clear-all';

// Recharge APIs
const String operatorFetchUrl = 'inspay/operator/fetch';
const String rechargePlansUrl = 'inspay/recharge/plans';
const String dthOperatorFetchUrl = 'fetch/dth/operators';
const String dthRechargePlansUrl = 'ekyc/fetch/dth/plan';
const String rofferUrl = 'ekyc/fetch/roffer';
const String operatorsByTypeUrl = 'ekyc/operators/';
const String fastagBillFetchUrl = 'ekyc/fetch/fastag_bill';
const String utilityBillFetchUrl = 'ekyc/fetch/bill';
const String nsdlNewPanUrl = 'ekyc/verify/pan_redirection';
const String creditCardBillFetchUrl = 'inspay/credit_card/bill_fetch';
const String createOrderUrl = 'inspay/recharge/create-order';
const String verifyPaymentUrl = 'inspay/recharge/verify';

// APIs keys
const String authorization = 'Authorization';
const String accept = 'Accept';
const String contentType = 'Content-Type';
//const String razorpayKeyConstant = 'rzp_live_TLKy91eX8x6Xum';
const String razorpayKeyConstant = 'rzp_test_TK6QbAu1THjboL';
