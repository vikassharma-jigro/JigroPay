import 'package:equatable/equatable.dart';

sealed class PanServiceState extends Equatable {
  const PanServiceState();

  @override
  List<Object?> get props => [];
}

final class PanServiceInitial extends PanServiceState {
  const PanServiceInitial();
}

final class PanServiceLoading extends PanServiceState {
  const PanServiceLoading();
}

final class PanServiceSuccess extends PanServiceState {
  const PanServiceSuccess({required this.redirectUrl});

  final String redirectUrl;

  @override
  List<Object?> get props => [redirectUrl];
}

final class PanServiceError extends PanServiceState {
  const PanServiceError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
