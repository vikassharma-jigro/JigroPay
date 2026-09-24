import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  HistoryRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient.instance;

  final ApiClient _apiClient;

  @override
  Future<Result<List<TransactionModel>>> fetchTransactionHistory({
    String? type,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null && type.isNotEmpty && type != 'All') {
        queryParams['type'] = type.toLowerCase();
      }
      if (status != null && status.isNotEmpty && status != 'All') {
        queryParams['status'] = status.toLowerCase();
      }

      final response = await _apiClient.get(
        AppEndpoints.transactionHistory,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final list = TransactionModel.listFromApiResponse(response.data);
      return Success(list);
    } on AppException catch (e) {
      return Error(ServerFailure(e.toString()));
    } catch (e) {
      return Error(ServerFailure('Failed to load transaction history: $e'));
    }
  }
}
