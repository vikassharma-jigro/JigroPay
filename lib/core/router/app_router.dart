import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/bill_payments/presentation/screens/generic_bill_payment_screen.dart';
import '../../features/home/presentation/screens/dashboard_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/pan_services/presentation/screens/pan_services_screen.dart';
import '../../features/recharge/presentation/screens/mobile_recharge_number_screen.dart';
import '../../features/recharge/presentation/screens/payment_success_screen.dart';
import '../../features/recharge/presentation/screens/recharge_plan_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final phone = (extra['phone'] ?? '').toString();
          final email = extra['email']?.toString();
          return OtpScreen(phone: phone, email: email);
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/mobile-recharge',
        name: 'mobile_recharge',
        builder: (context, state) => const MobileRechargeNumberScreen(),
      ),
      GoRoute(
        path: '/recharge-plans',
        name: 'recharge_plans',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final mobile = (extra['mobileNumber'] ?? extra['mobile'] ?? '')
              .toString();
          final contactName = extra['contactName']?.toString();
          return RechargePlanScreen(
            mobileNumber: mobile,
            contactName: contactName,
          );
        },
      ),
      GoRoute(
        path: '/bill-payment',
        name: 'bill_payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final serviceType = (extra['serviceType'] ?? 'electricity')
              .toString();
          final title = (extra['title'] ?? 'Bill Payment').toString();
          final label = (extra['accountNumberLabel'] ?? 'Consumer Number')
              .toString();
          final hint = (extra['accountNumberHint'] ?? 'Enter consumer number')
              .toString();
          return GenericBillPaymentScreen(
            serviceType: serviceType,
            title: title,
            accountNumberLabel: label,
            accountNumberHint: hint,
          );
        },
      ),
      GoRoute(
        path: '/pan-services',
        name: 'pan_services',
        builder: (context, state) => const PanServicesScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        name: 'payment_success',
        builder: (context, state) {
          final args =
              state.extra as PaymentSuccessArgs? ??
              const PaymentSuccessArgs(
                serviceName: 'Service',
                providerName: 'Provider',
                consumerNumber: '',
                amount: '0',
                transactionId: '',
              );
          return PaymentSuccessScreen(args: args);
        },
      ),
    ],
  );
}
