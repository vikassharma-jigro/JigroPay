import 'package:equatable/equatable.dart';
import '../../data/models/banner_model.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded({
    this.banners = const [],
    this.unreadCount = 0,
  });

  final List<BannerModel> banners;
  final int unreadCount;

  DashboardLoaded copyWith({
    List<BannerModel>? banners,
    int? unreadCount,
  }) {
    return DashboardLoaded(
      banners: banners ?? this.banners,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [banners, unreadCount];
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
