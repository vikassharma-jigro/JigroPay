import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigrotech/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/constants/app_colors.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/banner_carousel_widget.dart';
import '../widgets/home_header_widget.dart';
import '../widgets/service_categories_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Lazy API load on screen open only
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardCubit>().loadDashboard();
    });

    // Profile Picture
    context.read<AuthCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header (Avatar, Brand Title, Search, Notification bell)
                const HomeHeaderWidget(),
                const SizedBox(height: 16),

                // 2. Banner Carousel
                BlocBuilder<DashboardCubit, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoading) {
                      return Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    if (state is DashboardLoaded) {
                      return BannerCarouselWidget(banners: state.banners);
                    }
                    return const BannerCarouselWidget(banners: []);
                  },
                ),
                const SizedBox(height: 20),

                // 3. Service Categories
                const ServiceCategoriesWidget(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
