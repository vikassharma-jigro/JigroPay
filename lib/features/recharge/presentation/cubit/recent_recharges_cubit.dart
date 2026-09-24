import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/result.dart';
import '../../domain/usecases/get_recent_recharges_usecase.dart';
import 'recent_recharges_state.dart';

class RecentRechargesCubit extends Cubit<RecentRechargesState> {
  RecentRechargesCubit({
    required GetRecentRechargesUseCase getRecentRechargesUseCase,
  })  : _getRecentRechargesUseCase = getRecentRechargesUseCase,
        super(const RecentRechargesInitial());

  final GetRecentRechargesUseCase _getRecentRechargesUseCase;

  Future<void> loadRecentRecharges() async {
    emit(const RecentRechargesLoading());
    final result = await _getRecentRechargesUseCase();
    switch (result) {
      case Success(:final data):
        emit(RecentRechargesLoaded(data));
      case Error(:final failure):
        emit(RecentRechargesError(failure.message));
    }
  }
}
