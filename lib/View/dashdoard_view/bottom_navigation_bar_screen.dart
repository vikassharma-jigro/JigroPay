import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/custom_dialog_widget.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'help_support_screen.dart';
import '../profile_view/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  String? id;
  bool? isFromHome;
  int? index;
  DashboardScreen({Key? key, this.id, this.isFromHome = false, this.index})
    : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;
  final PageController _pageController = PageController();
  bool back_dialog = false;

  @override
  void initState() {
    _selectedIndex = widget.index ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const <Widget>[
                HomeScreen(),
                HelpSupportScreen(),
                //QrCodeScreen(),
                HistoryScreen(),
                ProfileScreen(),
              ],
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigation(context),
      ),
    );
  }

  Widget cancelButton(context) {
    return TextButton(
      child: const Text("NO"),
      onPressed: () {
        setState(() {
          back_dialog = false;
        });
      },
    );
  }

  Widget continueButton(context) {
    return TextButton(
      child: const Text("YES"),
      onPressed: () {
        SystemNavigator.pop();
      },
    );
  }

  Future<bool> _onWillPop() async {
    final result = await showCustomConfirmDialog(
      context,
      title: 'Exit App',
      message: 'Do you want to quit JigroPay?',
      primaryButtonText: 'Yes',
      secondaryButtonText: 'No',
      onConfirm: () {
        SystemNavigator.pop();
      },
    );
    return result ?? false;
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [secondaryColor, primaryColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,

          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,

          selectedFontSize: 12,
          unselectedFontSize: 12,

          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),

          onTap: _onTappedBar,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(IconsaxPlusLinear.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconsaxPlusLinear.info_circle),
              label: "Help",
            ),

            BottomNavigationBarItem(
              icon: Icon(IconsaxPlusLinear.clock_1),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(IconsaxPlusLinear.user),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
