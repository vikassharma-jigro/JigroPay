import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../history/data/models/transaction_model.dart';
import '../../domain/repositories/recharge_repository.dart';
import '../models/operator_model.dart';
import '../models/order_model.dart';
import '../models/recharge_plan_model.dart';

class RechargeRepositoryImpl implements RechargeRepository {
  RechargeRepositoryImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<OperatorModel>> fetchOperator({
    required String mobileNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        AppEndpoints.operatorFetch,
        data: {'mobile': mobileNumber},
      );
      _apiClient.throwIfError(response);

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final operator = OperatorModel.fromApiResponse(data);
        return Success(operator);
      }
      return const Error(ServerFailure('Failed to parse operator details'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<CategorisedPlans>> fetchPlans({
    required String mobileNumber,
    required String opcode,
    required String circle,
    bool isDth = false,
  }) async {
    try {
      final path = isDth
          ? AppEndpoints.dthRechargePlans
          : AppEndpoints.rechargePlans;
      final body = {
        if (isDth) 'dth_number': mobileNumber else 'mobile': mobileNumber,
        'opcode': opcode,
        if (!isDth) 'circle': circle,
        if (isDth) 'orderid': DateTime.now().millisecondsSinceEpoch.toString(),
        if (!isDth) 'is_dth': false,
        if (!isDth) 'is_roffer': false,
      };

      final response = await _apiClient.post(path, data: body);
      _apiClient.throwIfError(response);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Success(CategorisedPlans.fromApiResponse(data));
      } else if (data is List) {
        return Success(CategorisedPlans.fromApiResponse({'data': data}));
      }
      return const Error(ServerFailure('Failed to load plans'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<RechargePlanModel>>> fetchRoffers({
    required String mobileNumber,
    required String opcode,
  }) async {
    try {
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      final response = await _apiClient.post(
        AppEndpoints.rOffer,
        data: {'mobile': mobileNumber, 'opcode': opcode, 'orderid': orderId},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final plans = CategorisedPlans.fromApiResponse(data).allPlans;
        return Success(plans);
      } else if (data is List) {
        final plans = data
            .whereType<Map<String, dynamic>>()
            .map(RechargePlanModel.fromJson)
            .toList();
        return Success(plans);
      }
      return const Success([]);
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderModel>> createOrder({
    required String opcode,
    required String number,
    required double amount,
    String? type,
    String? fetchId,
  }) async {
    try {
      final body = {
        'opcode': opcode,
        'number': number,
        'amount': amount.toString(),
        if (type != null && type.isNotEmpty) 'type': type,
        if (fetchId != null && fetchId.isNotEmpty) 'fetch_id': fetchId,
      };

      final response = await _apiClient.post(
        AppEndpoints.createOrder,
        data: body,
      );
      _apiClient.throwIfError(response);

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final order = OrderModel.fromJson(data);
        return Success(order);
      }
      return const Error(ServerFailure('Invalid order response'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaymentVerifyModel>> verifyPayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
    String? type,
  }) async {
    try {
      final body = {
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_signature': razorpaySignature,
        if (type != null && type.isNotEmpty) 'type': type,
      };

      final response = await _apiClient.post(
        AppEndpoints.verifyPayment,
        data: body,
      );
      _apiClient.throwIfError(response);

      final data = response.data;
      if (data is Map<String, dynamic>) {
        final verifyResult = PaymentVerifyModel.fromJson(data);
        return Success(verifyResult);
      }
      return const Error(ServerFailure('Invalid verification response'));
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TransactionModel>>> fetchRecentRecharges() async {
    try {
      final response = await _apiClient.get(AppEndpoints.recentRecharges);
      final transactions = TransactionModel.listFromApiResponse(response.data);
      return Success(transactions);
    } on AppException catch (e) {
      return Error(e.toFailure());
    } catch (e) {
      return Error(UnknownFailure(e.toString()));
    }
  }
}
