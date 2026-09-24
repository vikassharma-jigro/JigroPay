import '../../../../core/errors/result.dart';

abstract interface class PanServiceRepository {
  /// Initiates an NSDL PAN card application redirect for [mobileNumber].
  ///
  /// Returns the redirection URL on success.
  Future<Result<String>> initiatePanApplication({required String mobileNumber});
}
