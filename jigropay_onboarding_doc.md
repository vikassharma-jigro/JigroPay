# JigroPay — Comprehensive Technical Onboarding & Business Requirement Document

---

## Table of Contents
1. [Executive Summary](#1-executive-summary)
2. [Business Flow (End-to-End)](#2-business-flow-end-to-end)
3. [System Architecture](#3-system-architecture)
4. [Backend Deep-Dive (REST API / NestJS Backend Contract)](#4-backend-deep-dive-rest-api--nestjs-backend-contract)
5. [Frontend/Mobile Deep-Dive (Flutter)](#5-frontendmobile-deep-dive-flutter)
6. [File-by-File Reference (Critical Files)](#6-file-by-file-reference-critical-files)
7. [Environment & Local Setup](#7-environment--local-setup)
8. [Known Issues / Tech Debt / Risks](#8-known-issues--tech-debt--risks)
9. [Glossary & Domain Terms](#9-glossary--domain-terms)

---

## 1. Executive Summary

### What is JigroPay?
**JigroPay** is a digital utility payments, mobile recharge, and financial service mobile application tailored for Indian consumers. It allows users to make instant mobile recharges (Prepaid/Postpaid), DTH recharges, BBPS utility bill payments (Electricity, Water, Gas, FASTag, Landline, Credit Card bills), and apply for new PAN cards via NSDL redirection.

### Business Problem Solved
1. **Unified Payment Experience:** Aggregates multiple billers (utility boards, telecom operators, FASTag providers) into a single, seamless mobile interface using BBPS (Bharat Bill Payment System) and InsPay APIs.
2. **Instant digital settlement & Receipts:** Provides real-time transaction processing with instant downloadable PDF payment receipts and transaction history.
3. **Security & Frictionless Auth:** Uses OTP-based mobile authentication paired with device-level secure key storage and screen protection (anti-screenshot/recording).

### Target Audience & Users
- **End Consumers (Retail Users):** Mobile users in India making daily/monthly utility payments and mobile recharges.
- **Partners / Channel Agents:** Users authenticating via partner streams to process transactions on behalf of customers.

---

## 2. Business Flow (End-to-End)

```
[User Device] ---> (1. Onboarding/Auth) ---> (2. Service Selection) ---> (3. Bill Fetch/Plan Selection)
                                                                                  |
[Success Screen / Receipt PDF] <--- (5. Verification & Fulfilment) <--- (4. Razorpay Checkout)
```

### 2.1 App Launch & Authentication Flow
1. **App Launch & Splash:** User opens JigroPay. [`SplashScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/splash/presentation/screens/splash_screen.dart) executes [`CheckAuthStatusUseCase`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/domain/usecases/check_auth_status_usecase.dart).
   - If first time: User is navigated to `/onboarding`.
   - If authenticated (valid `access_token` in [`StorageService`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/storage_service.dart)): Navigated directly to `/dashboard`.
   - If unauthenticated: Navigated to `/login`.
2. **Login / OTP Request:** User enters a 10-digit mobile number on [`LoginScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/login_screen.dart).
   - Calls `POST /api/auth/send-otp`.
   - On success, navigates to `/otp`.
3. **OTP Verification:** User enters 4/6-digit OTP on [`OtpScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/otp_screen.dart).
   - Calls `POST /api/auth/verify-otp` with `phone`, `otp`, and `fcm_token`.
   - Backend returns JWT `access_token` and user profile object.
   - If user is new / unregistered: API prompts user to complete signup on [`SignUpScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/signup_screen.dart) (`POST /api/auth/register`).
   - Token is encrypted and saved into iOS Keychain / Android EncryptedSharedPreferences via [`StorageService`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/storage_service.dart).

### 2.2 Mobile Recharge Flow
1. **Number & Operator Selection:** User enters/selects mobile contact on [`MobileRechargeNumberScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/mobile_recharge_number_screen.dart).
   - App automatically triggers `POST /api/inspay/operator/fetch` to auto-detect operator (e.g., Jio, Airtel, VI) and circle (e.g., Delhi, Rajasthan).
2. **Plan & R-Offer Selection:** On [`RechargePlanScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/recharge_plan_screen.dart):
   - Calls `POST /api/inspay/recharge/plans` to load categorized recharge plans (Unlimited, Data, Talktime, OTT).
   - Concurrently calls `POST /api/ekyc/fetch/roffer` to fetch customized operator offers (R-Offers).
3. **Order Creation:** User selects a plan and taps Pay.
   - Calls `POST /api/inspay/recharge/create-order` with `opcode`, `number`, `amount`.
   - Backend generates a Razorpay Order ID (`razorpay_order_id`) and returns order details.
4. **Razorpay Payment Gateway:**
   - [`PaymentService`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/payment_service.dart) opens native Razorpay SDK checkout modal.
   - User completes payment via UPI, Debit/Credit Card, NetBanking, or Wallet.
5. **Payment Verification & Operator Fulfillment:**
   - App receives `razorpay_payment_id`, `razorpay_order_id`, `razorpay_signature`.
   - Calls `POST /api/inspay/recharge/verify`.
   - Backend verifies signature with Razorpay servers and dispatches recharge to telecom operator.
   - Navigates to [`PaymentSuccessScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/payment_success_screen.dart).

### 2.3 BBPS & Utility Bill Payment Flow
1. **Category Selection:** From [`DashboardScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/home/presentation/screens/dashboard_screen.dart), user selects service category (Electricity, Water, Gas, FASTag, DTH, Credit Card).
2. **Biller Selection & Account Fetch:** [`GenericBillPaymentScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/presentation/screens/generic_bill_payment_screen.dart) loads billers via `GET /api/ekyc/operators/{serviceType}`.
   - User inputs Consumer Number / Account Number.
   - Triggers `POST /api/ekyc/fetch/bill` (or `fastag_bill` / `credit_card/bill_fetch`).
   - Returns customer name, due date, bill amount, and `fetch_id`.
3. **Bill Settlement & Verification:**
   - Calls `POST /api/inspay/recharge/create-order` with `fetch_id`, `opcode`, `consumer_id`, `amount`.
   - Opens Razorpay checkout modal.
   - Verifies payment via `POST /api/inspay/recharge/verify`.

### 2.4 Transaction History & PDF Receipt Download
1. **History List:** User opens History tab on [`DashboardScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/home/presentation/screens/dashboard_screen.dart).
   - Calls `GET /api/auth/transaction-history`.
2. **Receipt & Download:** Tapping any transaction opens [`PaymentDetailsScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/presentation/screens/payment_details_screen.dart) showing [`PaymentReceiptWidget`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/presentation/widgets/payment_receipt_widget.dart).
   - Generates pixel-perfect PDF using `pdf` & `path_provider` packages.
   - Supports sharing via `share_plus` and opening with `open_file`.

---

## 3. System Architecture

### 3.1 Diagram

```
+-------------------------------------------------------------------------+
|                        FLUTTER MOBILE CLIENT                            |
|  [Presentation Layer]  Cubits / Screens / Widgets                      |
|  [Domain Layer]        UseCases / Repository Interfaces / Entities      |
|  [Data Layer]          Repository Impl / DTO Models / Local Storage    |
+-------------------------------------------------------------------------+
       |                                     |                   |
       | HTTPS / REST (Dio)                  | Native SDK        | FCM Push
       v                                     v                   v
+-----------------------+           +------------------+ +----------------+
|  JIGROPAY BACKEND API |           | RAZORPAY GATEWAY | |  FIREBASE FCM  |
|  https://bbps.jigropay|           | (Checkout/Verify)| | (Notifications)|
|         .com/api/     |           +------------------+ +----------------+
+-----------------------+
       |
       +------------------------------------+--------------------+
       |                                    |                    |
       v                                    v                    v
+------------------+               +------------------+ +----------------+
|  INSPAY RECHARGE |               |    BBPS GATEWAY  | |  NSDL PAN API  |
|       API        |               | (Bill Fetch/Pay) | | (Redirection)  |
+------------------+               +------------------+ +----------------+
```

### 3.2 Tech Stack (Verified in Codebase)
- **Framework & Language:** Flutter SDK (`^3.9.2`), Dart 3.9
- **State Management:** `flutter_bloc` (v9.1.1), `equatable` (v2.0.7)
- **Navigation:** `go_router` (v15.1.2)
- **HTTP & Networking:** `dio` (v5.11.1), `pretty_dio_logger` (v1.4.0)
- **Local Storage:** `flutter_secure_storage` (v11.2.0 - Keychain/EncryptedSharedPrefs), `shared_preferences` (v2.5.3)
- **Payment Gateway:** `razorpay_flutter` (v1.3.7)
- **Push Notifications:** `firebase_core` (v3.13.1), `firebase_messaging` (v15.2.5), `flutter_local_notifications` (v18.0.1)
- **PDF Generation & File Sharing:** `pdf` (v3.11.2), `path_provider` (v2.1.5), `open_file` (v3.5.10), `share_plus` (v13.3.0)
- **Security & UI Protection:** `screen_protector` (v1.4.0 - screenshot/recording prevention)

---

## 4. Backend Deep-Dive (REST API / NestJS Backend Contract)

> **Note on Backend Hosting:** The JigroPay backend runs at `https://bbps.jigropay.com/api/`. Below is the complete REST API contract derived from the client network implementation and DTO models. *Internal backend server details (such as NestJS entity models or DB schema) are not inside this client repository and are explicitly flagged.*

### 4.1 Authentication & Header Requirements
- **Auth Scheme:** Bearer Token JWT in HTTP Header.
  ```http
  Authorization: Bearer <access_token>
  Accept: application/json
  Content-Type: application/json
  ```
- **Unauthorized Handling:** Any HTTP `401 Unauthorized` response automatically triggers a broadcast on [`ApiClient.instance.unauthorizedStream`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/network/api_client.dart), logging out the user and routing to `/login`.

### 4.2 Complete API Endpoints Reference Table

| Method | Route | Purpose | Auth Req? | Request Body / Parameters | Response Shape |
|---|---|---|---|---|---|
| `POST` | `auth/send-otp` | Send login OTP to mobile | No | `{"phone": "9876543210"}` | `{"status": true, "message": "OTP sent"}` |
| `POST` | `auth/verify-otp` | Verify OTP & obtain JWT | No | `{"phone": "...", "otp": "1234", "fcm_token": "..."}` | `{"status": true, "token": "JWT...", "user": {...}}` |
| `POST` | `auth/register` | Register new user profile | No | `{"name": "...", "email": "...", "phone": "..."}` | `{"status": true, "token": "JWT...", "user": {...}}` |
| `GET` | `auth/profile` | Fetch authenticated user profile | Yes | None | `{"status": true, "user": {...}}` |
| `POST` | `auth/profile/update` | Multipart update name, email, avatar | Yes | Multipart: `name`, `email`, `profile_image` | `{"status": true, "user": {...}}` |
| `POST` | `auth/logout` | Invalidate token on server | Yes | None | `{"status": true}` |
| `GET` | `banners` | Fetch home promo banners | No | None | `{"status": true, "data": [{"image": "..."}]}` |
| `GET` | `cms/{slug}` | Fetch privacy policy / terms HTML | No | Path param slug e.g. `privacy-policy` | `{"status": true, "data": {"content": "<html..."}}` |
| `GET` | `faqs` | Fetch FAQ list | No | None | `{"status": true, "data": [...]}` |
| `POST` | `auth/enquiries` | Submit support enquiry ticket | Yes | `{"subject": "...", "description": "...", "category": "..."}` | `{"status": true, "message": "Submitted"}` |
| `GET` | `auth/transaction-history` | Fetch user transaction history | Yes | None | `{"status": true, "data": [...]}` |
| `GET` | `auth/notifications` | Fetch user notifications list | Yes | None | `{"status": true, "data": [...]}` |
| `GET` | `auth/notifications/fetch-unread` | Count unread notifications | Yes | None | `{"status": true, "unread_count": 3}` |
| `POST` | `auth/notifications/mark-all-read` | Mark all notifications as read | Yes | None | `{"status": true}` |
| `POST` | `auth/notifications/clear-all` | Delete all notifications | Yes | None | `{"status": true}` |
| `POST` | `inspay/operator/fetch` | Auto-detect operator & circle | Yes | `{"mobile": "9876543210"}` | `{"status": true, "operator": "Jio", "opcode": "JO", "circle": "DL"}` |
| `POST` | `inspay/recharge/plans` | Fetch recharge plans | Yes | `{"mobile": "...", "opcode": "JO", "circle": "DL"}` | `{"status": true, "data": {"Unlimited": [...]}}` |
| `POST` | `fetch/dth/operators` | Fetch DTH operators list | Yes | None | `{"status": true, "data": [...]}` |
| `POST` | `ekyc/fetch/dth/plan` | Fetch DTH plans | Yes | `{"dth_number": "...", "opcode": "...", "orderid": "..."}` | `{"status": true, "data": [...]}` |
| `POST` | `ekyc/fetch/roffer` | Fetch customized R-Offers | Yes | `{"mobile": "...", "opcode": "...", "orderid": "..."}` | `{"status": true, "data": [...]}` |
| `GET` | `ekyc/operators/{type}` | Fetch billers by service type | Yes | Path slug (e.g. `electricity`, `water`, `fastag`) | `{"status": true, "data": [...]}` |
| `POST` | `ekyc/fetch/bill` | BBPS utility bill fetch | Yes | `{"consumer_id": "...", "opcode": "..."}` | `{"status": true, "amount": 500, "fetch_id": "..."}` |
| `POST` | `ekyc/fetch/fastag_bill` | BBPS FASTag bill fetch | Yes | `{"consumer_id": "...", "opcode": "..."}` | `{"status": true, "amount": 200, "fetch_id": "..."}` |
| `POST` | `inspay/credit_card/bill_fetch` | Credit Card bill fetch | Yes | `{"card": "...", "opcode": "...", "mobile": "..."}` | `{"status": true, "amount": 1000, "fetch_id": "..."}` |
| `POST` | `inspay/recharge/create-order` | Initiate Razorpay order | Yes | `{"opcode": "...", "number": "...", "amount": "100", "fetch_id": "..."}` | `{"status": true, "order_id": "order_K...", "key": "rzp_live_..."}` |
| `POST` | `inspay/recharge/verify` | Verify payment signature & fulfill | Yes | `{"razorpay_payment_id": "...", "razorpay_order_id": "...", "razorpay_signature": "..."}` | `{"status": true, "txid": "...", "operator_ref": "..."}` |
| `GET` | `inspay/recharge/latest` | Fetch recent recharges | Yes | None | `{"status": true, "data": [...]}` |
| `POST` | `ekyc/verify/pan_redirection` | Initiate NSDL PAN application | Yes | `{"name": "...", "dob": "...", "mobile": "..."}` | `{"status": true, "url": "https://nsdl..."}` |

### 4.3 Payment & Transaction Critical Logic (Precise Workflow)
1. **Order Creation:** Client sends `create-order` request with transaction details. Backend creates a pending transaction record in DB and calls Razorpay Orders API to produce a `razorpay_order_id`.
2. **Client Checkout:** Flutter app receives `order_id` and invokes Razorpay SDK modal.
3. **Verification & Idempotency:**
   - App submits `razorpay_payment_id`, `razorpay_order_id`, and HMAC `razorpay_signature` to `POST /api/inspay/recharge/verify`.
   - **Backend Verification:** Backend recalculates `HMAC_SHA256(order_id + "|" + payment_id, secret)` and compares with `razorpay_signature`.
   - **Fulfillment Dispatch:** On match, backend dispatches fulfillment payload to InsPay or BBPS gateway.
   - **Failure Handling:** If signature verification fails or operator fulfillment fails, backend updates status to `FAILED` or `PENDING` and triggers automatic refund workflow via Razorpay.

---

## 5. Frontend/Mobile Deep-Dive (Flutter)

### 5.1 Architecture Layering
JigroPay follows **Clean Architecture** organized by feature:
- `lib/core/`: Application-wide shared utilities, network client, services, constants, and global UI widgets.
- `lib/features/<feature_name>/`:
  - `data/`: [`models/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/data/models/user_model.dart) (API JSON DTOs), [`repositories/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/data/repositories/auth_repository_impl.dart) (Data fetching & error mapping).
  - `domain/`: [`repositories/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/domain/repositories/auth_repository.dart) (Interfaces), [`usecases/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/domain/usecases/send_otp_usecase.dart) (Business logic units).
  - `presentation/`: [`cubit/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/cubit/auth_cubit.dart) (State Management), [`screens/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/login_screen.dart) & [`widgets/`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/presentation/widgets/payment_receipt_widget.dart).

### 5.2 State Management: BLoC / Cubit Breakdown

| Cubit Class | File Path | Responsibilities & Managed States | Key Functions / Event Handlers |
|---|---|---|---|
| [`AuthCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/cubit/auth_cubit.dart) | `lib/features/auth/presentation/cubit/` | Handles auth lifecycle (`AuthInitial`, `AuthLoading`, `OtpSent`, `Authenticated`, `Unauthenticated`, `AuthError`). | `sendOtp()`, `verifyOtp()`, `register()`, `logout()`, `checkAuthStatus()`, `updateProfile()` |
| [`RechargeCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/cubit/recharge_cubit.dart) | `lib/features/recharge/presentation/cubit/` | Manages mobile operator detection, plan loading, order creation, payment checkout, and verification. | `fetchOperator()`, `fetchPlans()`, `fetchROffers()`, `createOrderAndPay()`, `verifyPayment()` |
| [`RecentRechargesCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/cubit/recent_recharges_cubit.dart) | `lib/features/recharge/presentation/cubit/` | Fetches and manages state for recent recharges on recharge screens (`RecentRechargesLoading`, `RecentRechargesLoaded`). | `fetchRecentRecharges()` |
| [`BillPaymentCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/presentation/cubit/bill_payment_cubit.dart) | `lib/features/bill_payments/presentation/cubit/` | Handles BBPS biller list loading, bill amount fetching, order generation, and payment verification. | `fetchBillers()`, `fetchBillDetails()`, `createOrderAndPay()`, `verifyPayment()` |
| [`HistoryCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/presentation/cubit/history_cubit.dart) | `lib/features/history/presentation/cubit/history_cubit.dart` | Fetches transaction history, handles searching/filtering transactions. | `fetchTransactionHistory()`, `searchTransactions()` |
| [`NotificationCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/notifications/presentation/cubit/notification_cubit.dart) | `lib/features/notifications/presentation/cubit/` | Fetches notifications, manages unread badge count, mark as read, clear notifications. | `fetchNotifications()`, `markAllRead()`, `clearAll()` |
| [`HelpSupportCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/help_support/presentation/cubit/help_support_cubit.dart) | `lib/features/help_support/presentation/cubit/` | Loads FAQs and handles ticket submission for customer support. | `fetchFaqs()`, `submitEnquiry()` |
| [`DashboardCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/home/presentation/cubit/dashboard_cubit.dart) | `lib/features/home/presentation/cubit/` | Loads home promo banners and bottom navigation index (`DashboardInitial`, `DashboardLoaded`). | `loadDashboardData()`, `changeTab()` |
| [`SplashCubit`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/splash/presentation/cubit/splash_cubit.dart) | `lib/features/splash/presentation/cubit/` | Coordinates initial splash animation timer and authentication routing check. | `initSplash()` |

### 5.3 Navigation & Route Map (`GoRouter`)
- `/` -> [`SplashScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/splash/presentation/screens/splash_screen.dart)
- `/onboarding` -> [`OnboardingScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/onboarding_screen.dart)
- `/login` -> [`LoginScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/login_screen.dart)
- `/signup` -> [`SignUpScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/signup_screen.dart)
- `/otp` -> [`OtpScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/otp_screen.dart) (Params: `phone`, `email`)
- `/dashboard` -> [`DashboardScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/home/presentation/screens/dashboard_screen.dart) (Bottom Nav: Home, History, Profile)
- `/search` -> [`SearchScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/search/presentation/screens/search_screen.dart)
- `/notifications` -> [`NotificationScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/notifications/presentation/screens/notification_screen.dart)
- `/mobile-recharge` -> [`MobileRechargeNumberScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/mobile_recharge_number_screen.dart)
- `/recharge-plans` -> [`RechargePlanScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/recharge_plan_screen.dart) (Params: `mobileNumber`, `contactName`)
- `/bill-payment` -> [`GenericBillPaymentScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/presentation/screens/generic_bill_payment_screen.dart) (Params: `serviceType`, `title`, `accountNumberLabel`, `accountNumberHint`)
- `/payment-success` -> [`PaymentSuccessScreen`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/payment_success_screen.dart) (Params: `PaymentSuccessArgs`)

---

## 6. File-by-File Reference (Critical Files)

1. [`lib/main.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/main.dart): App bootstrap file. Initializes Firebase, [`StorageService`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/storage_service.dart), [`NotificationService`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/notification_service.dart), screenshot prevention via `screen_protector`, and sets system UI overlay style.
2. [`lib/app.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/app.dart): Root widget (`JigroPayApp`). Sets up global `MultiBlocProvider` (`AuthCubit`, `SplashCubit`), subscribes to `ApiClient.unauthorizedStream` for auto 401 logout, and configures `MaterialApp.router` with theme data.
3. [`lib/core/router/app_router.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/router/app_router.dart): Central `GoRouter` configuration defining all application routes and extra argument parsers.
4. [`lib/core/network/api_client.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/network/api_client.dart): Singleton HTTP client built on Dio. Automatically attaches Bearer tokens, logs requests in debug mode using `PrettyDioLogger`, performs internet lookup assertions, and maps Dio errors to typed `AppException` instances.
5. [`lib/core/services/storage_service.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/storage_service.dart): Local persistence manager. Encrypts sensitive auth tokens (`access_token`, `member_token`, `member_id`, `fcm_token`) using `FlutterSecureStorage` and non-sensitive flags using `SharedPreferences`.
6. [`lib/core/services/payment_service.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/payment_service.dart): Native Razorpay SDK wrapper using `Completer<PaymentResult>`. Operates cleanly without `BuildContext` dependencies.
7. [`lib/core/services/notification_service.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/notification_service.dart): Manages Firebase Cloud Messaging (FCM) permissions, token registration, background messaging handlers, and local notification display with image attachments.
8. [`lib/core/constants/app_endpoints.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/constants/app_endpoints.dart): Central registry of base URL (`https://bbps.jigropay.com/api/`) and all REST endpoint path strings.
9. [`lib/features/auth/data/repositories/auth_repository_impl.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/data/repositories/auth_repository_impl.dart): Concrete auth data repository implementing `sendOtp`, `verifyOtp`, `register`, `getProfile`, `updateProfile`, and `logout`.
10. [`lib/features/auth/presentation/cubit/auth_cubit.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/cubit/auth_cubit.dart): Cubit state controller managing user authentication state, login flows, and token clearing.
11. [`lib/features/auth/data/models/user_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/data/models/user_model.dart): Data model representing user profile attributes (`id`, `name`, `email`, `phone`, `profileImage`, `memberId`, `walletBalance`). Includes custom JSON parsers.
12. [`lib/features/recharge/data/repositories/recharge_repository_impl.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/data/repositories/recharge_repository_impl.dart): Handles operator fetch, recharge plan fetch, R-offer fetch, order creation, payment verification, and recent recharges list.
13. [`lib/features/recharge/presentation/cubit/recharge_cubit.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/cubit/recharge_cubit.dart): State manager orchestrating mobile & DTH recharge flows from selection to payment completion.
14. [`lib/features/recharge/data/models/order_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/data/models/order_model.dart): Models Razorpay order responses (`OrderModel`) and payment verification responses (`PaymentVerifyModel`).
15. [`lib/features/recharge/data/models/recharge_plan_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/data/models/recharge_plan_model.dart): Models plan details (price, validity, talktime, data, description) and categorizes plans (`CategorisedPlans`).
16. [`lib/features/bill_payments/data/repositories/bill_payment_repository_impl.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/data/repositories/bill_payment_repository_impl.dart): Implements BBPS biller discovery by service type, bill details fetch, bill order creation, and payment verification.
17. [`lib/features/bill_payments/presentation/cubit/bill_payment_cubit.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/presentation/cubit/bill_payment_cubit.dart): Cubit driving generic utility bill payment UI flow.
18. [`lib/features/bill_payments/data/models/biller_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/data/models/biller_model.dart): Model for BBPS billers (`name`, `opcode`, `serviceType`, `iconUrl`).
19. [`lib/features/bill_payments/data/models/bill_details_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/data/models/bill_details_model.dart): Model for fetched utility bill details (`customerName`, `billAmount`, `dueDate`, `billDate`, `fetchId`).
20. [`lib/features/history/data/repositories/history_repository_impl.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/data/repositories/history_repository_impl.dart): Fetches transaction history list from API endpoint `auth/transaction-history`.
21. [`lib/features/history/presentation/cubit/history_cubit.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/presentation/cubit/history_cubit.dart): State manager for filtering, searching, and displaying transaction history.
22. [`lib/features/history/data/models/transaction_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/data/models/transaction_model.dart): Data model representing transaction items (`txid`, `amount`, `status`, `operatorName`, `date`, `consumerNumber`, `paymentMethod`).
23. [`lib/features/history/presentation/widgets/payment_receipt_widget.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/presentation/widgets/payment_receipt_widget.dart): UI widget and PDF generator rendering payment receipt cards with share & download capabilities.
24. [`lib/features/auth/presentation/screens/login_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/login_screen.dart): Login view providing mobile number input with regex validation.
25. [`lib/features/auth/presentation/screens/otp_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/otp_screen.dart): Pin code entry screen supporting SMS autofill and resend OTP timer.
26. [`lib/features/auth/presentation/screens/signup_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/auth/presentation/screens/signup_screen.dart): Profile registration screen for new users (Full Name, Email Address).
27. [`lib/features/recharge/presentation/screens/mobile_recharge_number_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/mobile_recharge_number_screen.dart): Mobile recharge screen with device contact picker integration (`flutter_contacts`).
28. [`lib/features/recharge/presentation/screens/recharge_plan_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/recharge_plan_screen.dart): Tabbed plan browser with category filters and R-Offer highlight banner.
29. [`lib/features/bill_payments/presentation/screens/generic_bill_payment_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/bill_payments/presentation/screens/generic_bill_payment_screen.dart): Dynamic utility bill payment screen supporting Electricity, Water, Gas, FASTag, and Credit Card bills.
30. [`lib/features/recharge/presentation/screens/payment_success_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/presentation/screens/payment_success_screen.dart): Animated payment completion screen with transaction breakdown and receipt view.
31. [`lib/features/profile/presentation/screens/profile_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/profile/presentation/screens/profile_screen.dart): Profile management screen supporting image upload (`image_picker`), account settings, and logout action.
32. [`lib/features/notifications/presentation/screens/notification_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/notifications/presentation/screens/notification_screen.dart): Notifications screen with mark all read and clear all features.
33. [`lib/features/help_support/presentation/screens/help_support_screen.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/help_support/presentation/screens/help_support_screen.dart): FAQ accordion viewer and customer inquiry ticket form.
34. [`lib/core/widgets/cms_bottom_sheet.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/widgets/cms_bottom_sheet.dart): Bottom sheet for rendering HTML content (Privacy Policy, Terms of Service) using `flutter_widget_from_html_core`.
35. [`lib/core/widgets/generic_operator_list_widget.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/widgets/generic_operator_list_widget.dart): Searchable modal list widget for selecting telecom operators and BBPS billers.
36. [`lib/core/widgets/custom_dialogs.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/widgets/custom_dialogs.dart): Standardized app dialogs (Success, Error, Confirmation, Exit Prompt).
37. [`lib/app_utils/razorpay_helper.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/app_utils/razorpay_helper.dart): Legacy Razorpay helper retained for backwards compatibility.

---

## 7. Environment & Local Setup

### 7.1 Required Tools & Prerequisites
- **Flutter SDK:** `>= 3.9.2` (Dart SDK `^3.9.2`)
- **Android Studio / Xcode:** For mobile build targets.
- **Java Development Kit (JDK):** JDK 17 recommended for Gradle builds.

### 7.2 Credentials & Environment Variables
The application accepts configuration flags via Flutter's `--dart-define` command:

| Variable Name | Purpose | Example / Test Value | Location in Code |
|---|---|---|---|
| `RAZORPAY_KEY` | Razorpay API Key | `rzp_live_TLKy91eX8x6Xum` (Default in code) | [`lib/core/services/payment_service.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/payment_service.dart#L173) |

### 7.3 Step-by-Step Local Execution Instructions

1. **Clone & Navigate:**
   ```bash
   cd /Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1
   ```
2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Verify Firebase Configuration:**
   - Ensure `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` are in place (already configured in [`lib/firebase_options.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/firebase_options.dart)).
4. **Run Application:**
   ```bash
   # Run on connected Android device / emulator
   flutter run --dart-define=RAZORPAY_KEY=rzp_live_TLKy91eX8x6Xum

   # Run on iOS Simulator
   flutter run -d iPhone --dart-define=RAZORPAY_KEY=rzp_live_TLKy91eX8x6Xum
   ```

---

## 8. Known Issues / Tech Debt / Risks

> [!WARNING]
> **HIGH RISK — Hardcoded Razorpay Live Key Fallback:**
> [`lib/core/services/payment_service.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/payment_service.dart#L173) contains a hardcoded Razorpay Live Key (`rzp_live_TLKy91eX8x6Xum`) as default fallback. This key must be moved entirely to secret environment variables (`--dart-define`) to prevent unauthorized usage in production builds.

> [!IMPORTANT]
> **Fallback Customer Phone & Email in Razorpay Checkout:**
> In [`lib/core/services/payment_service.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/core/services/payment_service.dart#L101-L104), if user profile contact information is empty, default values `9694870658` and `user@jigropay.com` are passed to Razorpay prefill. This should be replaced with explicit user prompts.

> [!NOTE]
> **Data Type Parsing Fallbacks in Models:**
> Model parsers across [`transaction_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/history/data/models/transaction_model.dart#L311), [`order_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/data/models/order_model.dart#L110), and [`recharge_plan_model.dart`](file:///Users/apple/Documents/flutterdev/projects/office_projects/JigroPay1/lib/features/recharge/data/models/recharge_plan_model.dart#L145) contain inline type coercion helpers (`if (v is int) return v.toDouble();`). While functional, strict schema typing on the backend response is recommended.

> [!NOTE]
> **Lack of Offline Transaction Queue:**
> If network connectivity drops after Razorpay payment completion but before calling `POST /api/inspay/recharge/verify`, the payment succeeds in Razorpay but fulfillment requires manual backend reconciliation. An offline retry queue using local storage would improve resilience.

---

## 9. Glossary & Domain Terms

- **Opcode (Operator Code):** Short identifier assigned to telecom operators and billers (e.g., `JO` for Jio, `AT` for Airtel, `DSE` for Delhi Electricity).
- **Circle:** Telecom region code in India (e.g., `DL` for Delhi, `RJ` for Rajasthan, `MH` for Maharashtra).
- **Fetch ID (`fetch_id`):** Unique token returned by BBPS during bill lookup, required during payment creation to lock the bill amount.
- **BBPS (Bharat Bill Payment System):** NPCI-backed centralized bill payment ecosystem in India.
- **InsPay:** Third-party aggregator API utilized by JigroPay for mobile recharge, DTH, and utility bill processing.
- **R-Offer:** Real-time customized recharge offer generated dynamically by telecom operators for specific mobile numbers.
- **Member Token / Member ID:** Secondary agent/partner identity token stored securely for partner stream transactions.
- **NSDL PAN Redirection:** Automated web flow redirecting users to NSDL portal for new Permanent Account Number (PAN) card generation.
