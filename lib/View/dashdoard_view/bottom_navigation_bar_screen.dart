import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/auth_view/qr_code_screen.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import 'home_screen.dart';



class DashboardScreen extends StatefulWidget {
  String? id;
  bool? isFromHome;
  int?index;
  DashboardScreen({Key? key, this.id, this.isFromHome = false,this.index})
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
    _selectedIndex = widget.index??0;
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
                 HomeScreen(),
                 QrCodeScreen(),
                 HomeScreen(),
                 HomeScreen(),

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
              child: Text('Do you want to quit app?',style: TextStyle(color: blueColor,fontSize: 18,fontFamily: FontFamily.plusJakartaSansRegular),)),
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
                      width: MediaQuery.sizeOf(context).width/3,
                      padding: const EdgeInsets.only(left: 22,right: 22),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: blueColor)
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text('Yes',style: TextStyle(color: blueColor,fontSize: 18,fontFamily: FontFamily.plusJakartaSansRegular),))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                      height: 40,
                      width: MediaQuery.sizeOf(context).width/3,
                      padding: const EdgeInsets.only(left: 22,right: 22),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),color: blueColor,
                          border: Border.all(color: blueColor)
                      ),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text('No',style: TextStyle(color: white,fontSize: 18,fontFamily: FontFamily.plusJakartaSansRegular),))),
                ),
              ],
            ),
          ],
        );
      },
    );
    return shouldPop!;
  }

  _buildBottomNavigation(isMember) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom Navigation Bar
        BottomNavigationBar(
          backgroundColor: white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: pinkColor,
          unselectedItemColor: greyColor,
          selectedFontSize: 20,
          unselectedFontSize: 20,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: purpleGradientColor),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: pinkColor,
            overflow: TextOverflow.visible,
          ),
          onTap: (index) {
            _onTappedBar(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.help_outline),
              label: 'Help',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Center image ke jagah blank rakh do
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
          ],
        ),

        // 🔥 Center Circular Image Button
        Positioned(
          bottom: 25, // bar ke upar thoda sa
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              _onTappedBar(2); // center index par switch karega
            },
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: white, width: 4),
                gradient: const LinearGradient(
                  colors: [purpleGradientColor, pinkColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: Icon(Icons.qr_code,size: 30,color: white,)
              ),
            ),
          ),
        ),
      ],
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
