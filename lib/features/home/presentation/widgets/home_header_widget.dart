import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // User Avatar & Brand Title
        Row(
          children: [
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String? avatarUrl;
                if (state is AuthAuthenticated) {
                  avatarUrl = state.user.profileImageUrl;
                }
                return Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: (avatarUrl != null && avatarUrl.startsWith('http'))
                        ? Image.network(
                            avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: AppColors.secondary,
                              size: 24,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            color: AppColors.secondary,
                            size: 24,
                          ),
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            RichText(
              text: const TextSpan(
                text: 'Jigro',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppTypography.outfitBold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Pay',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppTypography.outfitBold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Search & Notifications Icons
        Row(
          children: [
            IconButton(
              icon: const Icon(
                IconsaxPlusLinear.search_normal,
                color: AppColors.black,
                size: 24,
              ),
              onPressed: () => context.push('/search'),
            ),
            BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                final unreadCount = state is DashboardLoaded
                    ? state.unreadCount
                    : 0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        IconsaxPlusLinear.notification,
                        color: AppColors.black,
                        size: 24,
                      ),
                      onPressed: () => context.push('/notifications'),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
