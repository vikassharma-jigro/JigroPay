import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/qr_code_screen.dart';
import 'package:jigrotech/View/bank_view/bank_list_screen.dart';
import 'package:jigrotech/View/bank_view/self_account_screen.dart';
import 'package:jigrotech/View/dashdoard_view/see_all_services.dart';
import 'package:jigrotech/View/dth_view/dth_service_screen.dart';
import 'package:jigrotech/View/fast_tag_view/fast_tag_screen.dart';
import 'package:jigrotech/View/gas_view/gas_services_screen.dart';
import 'package:jigrotech/View/insurance_view/bike_insurance_screen.dart';
import 'package:jigrotech/View/insurance_view/car_insurance_screen.dart';
import 'package:jigrotech/View/insurance_view/travle_insurance_countries_screen.dart';
import 'package:jigrotech/View/travle_booking_view/bus_view/bus_booking_point_screen.dart';
import 'package:jigrotech/View/travle_booking_view/train_view/train_booking_screen.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_images.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import '../bank_view/check_balance_screen.dart';
import '../bank_view/mobile_recharge_screen/recharge_plan_screen.dart';
import '../bank_view/money_transfer_screen.dart';
import '../comming_soon_screen.dart';
import '../electricity_bill/electricity_bill_service_screen.dart';
import '../insurance_view/accident_insurance_screen.dart';
import '../insurance_view/helth_insurance_screen.dart';
import '../insurance_view/term_life_insurance_screen.dart';
import '../travle_booking_view/flight_view/flight_booking_screen.dart';
import '../travle_booking_view/hotel_view/hotel_home_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<int, PageController> pageControllers =
      {}; // हर index के लिए PageController स्टोर करें
  Map<int, int> currentPositions = {};
  PageController controller = PageController(
    viewportFraction: 1,
    keepPage: true,
  );
  int currentPos = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pinkColor, purpleGradientColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: 5,
                        controller: PageController(
                          viewportFraction: 1.0,
                        ), // अलग PageController
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (i) {
                          setState(() {
                            // currentPositions[index] = i;
                          });
                        },
                        itemBuilder: (BuildContext context, itemIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(AppImages.bannerIcon),
                          );
                        },
                      ),

                      // Page Indicator
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildPageIndicator(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          text(
                            "Money Transfers",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommingSoonScreen(),
                                ),
                              );
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => RechargePlanScreen(),));
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: darkPinkColor,
                                  ),
                                  child: Image.asset(
                                    AppImages.user1Icon,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(height: 5),
                                text(
                                  "To Mobile\nNumber",
                                  textColor: blackColor,
                                  fontSize: 11,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BankListScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: darkPinkColor,
                                  ),
                                  child: Image.asset(
                                    AppImages.bankIcon,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(height: 5),
                                text(
                                  "To Bank/\n UPI ID",
                                  textColor: blackColor,
                                  fontSize: 11,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SelfAccountScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: darkPinkColor,
                                  ),
                                  child: Image.asset(
                                    AppImages.selfAcIcon,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(height: 5),
                                text(
                                  "To Self \nAccount",
                                  textColor: blackColor,
                                  fontSize: 11,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckBalanceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: darkPinkColor,
                                  ),
                                  child: Image.asset(
                                    AppImages.checkBalIcon,
                                    height: 30,
                                  ),
                                ),
                                SizedBox(height: 5),
                                text(
                                  "Check\nBalance",
                                  textColor: blackColor,
                                  fontSize: 11,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// QR Code Page Redirect
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            text(
                              "Receive Money",
                              textColor: blackColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios),
                        Row(
                          children: [
                            Icon(Icons.qr_code_scanner),
                            SizedBox(width: 10),
                            text(
                              "UPI ID: 8888777766@ybl",
                              textColor: redColor,
                              fontSize: 13,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              pinkColor, // Gradient का पहला color
                              purpleGradientColor, // Gradient का दूसरा color
                            ],
                            begin: Alignment.topLeft, // Gradient की शुरुआत
                            end: Alignment.bottomRight, // Gradient का अंत
                          ),
                          //color: purpleGradientColor
                        ),
                        child: Column(
                          children: [
                            Image.asset(AppImages.walletIcon, height: 40),
                            SizedBox(height: 5),
                            text(
                              "Jigro Wallet",
                              textColor: white,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              pinkColor, // Gradient का पहला color
                              purpleGradientColor, // Gradient का दूसरा color
                            ],
                            begin: Alignment.topLeft, // Gradient की शुरुआत
                            end: Alignment.bottomRight, // Gradient का अंत
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(AppImages.RewardiconIcon, height: 40),
                            SizedBox(height: 5),
                            text(
                              "Rewards",
                              textColor: white,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              pinkColor, // Gradient का पहला color
                              purpleGradientColor, // Gradient का दूसरा color
                            ],
                            begin: Alignment.topLeft, // Gradient की शुरुआत
                            end: Alignment.bottomRight, // Gradient का अंत
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(AppImages.refericonIcon, height: 40),
                            SizedBox(height: 5),
                            text(
                              "Refer & Get ₹50",
                              textColor: white,
                              fontSize: 10,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Recharge & Pay Bills",
                            textColor: blackColor,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: lightWhiteColor,
                            ),
                            child: text(
                              "My Bills",
                              textColor: redColor,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoneyTransferScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppImages.mobilerechargeIcon,
                                  height: 30,
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Mobile\nRecharge",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FastTagScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: orangeColor,
                                  ),
                                  child: text(
                                    "Popular",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Buy FASTag",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DthServiceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.dishiconIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "DTH",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ElectricityBillServiceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppImages.electricityIcon,
                                  height: 30,
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Electricity",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommingSoonScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppImages.rentpaymentIcon,
                                  height: 30,
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Rent Payment",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommingSoonScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppImages.loanRepaymentIcon,
                                  height: 30,
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Loan\nRepayment",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GasServicesScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.cylinderIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Book A\nCylinder",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SeeAllServicesScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: darkPinkColor,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: blackColor,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "See All",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(AppImages.upiIcon, height: 20),

                          Container(color: greyColor, height: 30, width: 1),
                          text(
                            "PIN-less Payments",
                            textColor: blackColor,
                            fontSize: 12,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: pinkColor,
                            ),
                            child: text(
                              "Try Now",
                              textColor: blackColor,
                              fontSize: 11,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "Insurance",
                        textColor: blackColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BikeInsuranceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.bikeIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Bike",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CarInsuranceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.carIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Car",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HealthInsuranceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.helthIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Health",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AccidentInsuranceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.accidentIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Accident",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TermLifeInsuranceScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.termLifeIcon, height: 30),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Term LIfe",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TravelInsuranceCountriesScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppImages.traveLinsuranceIcon,
                                  height: 30,
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Travel\nInsurance",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommingSoonScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  AppImages.insuranceRenewalIcon,
                                  height: 30,
                                ),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Insurance\nRenewal",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: darkPinkColor,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: blackColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Center(
                                child: text(
                                  "See All",
                                  isCentered: true,
                                  textColor: blackColor,
                                  fontSize: 11,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: 5,
                        controller: PageController(
                          viewportFraction: 1.0,
                        ), // अलग PageController
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (i) {
                          setState(() {
                            // currentPositions[index] = i;
                          });
                        },
                        itemBuilder: (BuildContext context, itemIndex) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(AppImages.bannerIcon),
                          );
                        },
                      ),

                      // Page Indicator
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _buildPageIndicator(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(
                        "Travel Bookings",
                        textColor: blackColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FlightBookingScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.flightsIcon, height: 40),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Flights",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BusBookingPointScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.busIcon, height: 40),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Bus",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrainBookingScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.trainsIcon, height: 40),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Trains",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HotelHomeScreen(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImages.hotelIcon, height: 40),
                                SizedBox(height: 5),
                                Center(
                                  child: text(
                                    "Hotels",
                                    isCentered: true,
                                    textColor: blackColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator(int count) {
    return List.generate(count, (i) => _indicator(i == currentPos));
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        height: isActive ? 10 : 7.0,
        width: isActive ? 10 : 7.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? pinkColor : purpleGradientColor,
        ),
      ),
    );
  }
}
