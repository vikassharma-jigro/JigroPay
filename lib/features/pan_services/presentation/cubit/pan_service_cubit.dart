import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../domain/usecases/initiate_pan_application_usecase.dart';
import 'pan_service_state.dart';

class PanServiceCubit extends Cubit<PanServiceState> {
  PanServiceCubit({
    required InitiatePanApplicationUseCase initiatePanApplicationUseCase,
  })  : _initiatePanApplicationUseCase = initiatePanApplicationUseCase,
        super(const PanServiceInitial());

  final InitiatePanApplicationUseCase _initiatePanApplicationUseCase;

  Future<void> initiatePanApplication({required String mobileNumber}) async {
    emit(const PanServiceLoading());

    final result = await _initiatePanApplicationUseCase(
      mobileNumber: mobileNumber.trim(),
    );

    switch (result) {
      case Success(:final data):
        emit(PanServiceSuccess(redirectUrl: data));
      case Error(:final failure):
        emit(PanServiceError(message: failure.message));
    }
  }

  void reset() {
    emit(const PanServiceInitial());
  }
}
