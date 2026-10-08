import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigrotech/core/constants/app_assets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/custom_dialogs.dart';
import '../../../help_support/presentation/screens/help_support_screen.dart';
import '../../../history/presentation/screens/history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/usecases/get_banners_usecase.dart';
import '../../domain/usecases/get_unread_notifications_count_usecase.dart';
import '../cubit/dashboard_cubit.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  Future<void> _handleBackPress() async {
    final shouldExit = await showConfirmDialog(
      context,
      title: 'Exit App',
      message: 'Do you want to quit JigroPay?',
      confirmText: 'Exit',
      cancelText: 'Cancel',
      onConfirm: () => SystemNavigator.pop(),
    );
    if (shouldExit == true) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeRepo = HomeRepositoryImpl();

    return BlocProvider(
      create: (context) => DashboardCubit(
        getBannersUseCase: GetBannersUseCase(homeRepo),
        getUnreadNotificationsCountUseCase: GetUnreadNotificationsCountUseCase(
          homeRepo,
        ),
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (_currentIndex != 0) {
            _onTabTapped(0);
          } else {
            _handleBackPress();
          }
        },
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const HelpSupportScreen(),
              const HistoryScreen(),
              ProfileScreen(onNavigateTab: _onTabTapped),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      backgroundColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.black,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: AppTypography.outfitBold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: AppTypography.outfitMedium,
      ),
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppAssets.homeIcon),
          activeIcon: SvgPicture.asset(AppAssets.homeFilledIcon),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppAssets.helpIcon),
          activeIcon: SvgPicture.asset(AppAssets.helpFilledIcon),
          label: "Help",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppAssets.historyIcon),
          activeIcon: SvgPicture.asset(AppAssets.historyFilledIcon),
          label: "History",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(AppAssets.profileIcon),
          activeIcon: SvgPicture.asset(AppAssets.profileFilledIcon),
          label: "Profile",
        ),
      ],
    );
  }
}
