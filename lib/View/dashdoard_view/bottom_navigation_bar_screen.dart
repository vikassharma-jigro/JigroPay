import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/auth_view/qr_code_screen.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
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
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: const Align(
            alignment: Alignment.center,
            child: Text(
              'Do you want to quit app?',
              style: TextStyle(
                color: blueColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansRegular,
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width / 3,
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: blueColor),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: blueColor,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.sizeOf(context).width / 3,
                    padding: const EdgeInsets.only(left: 22, right: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: blueColor,
                      border: Border.all(color: blueColor),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: white,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    return shouldPop!;
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            secondaryColor,
            primaryColor,

          ],
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

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),

          onTap: _onTappedBar,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: "Help",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
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
