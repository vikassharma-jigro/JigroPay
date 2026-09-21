import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:jigrotech/View/dth_view/dth_service_screen.dart';
import 'package:jigrotech/View/fast_tag_view/fast_tag_screen.dart';
import 'package:jigrotech/View/gas_view/gas_services_screen.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/app_images.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../getx_controller/auth_controller.dart';
import '../../getx_controller/notification_controller.dart';
import '../notification_view/notification_screen.dart';
import '../bank_view/mobile_recharge_screen/mobile_recharge_number_screen.dart';
import '../electricity_bill/electricity_bill_service_screen.dart';
import '../gas_view/piped_gas_services_screen.dart';
import '../insurance_view/insurance_provider_screen.dart';
import '../loan_repayment_view/loan_repayment_screen.dart';
import '../cable_view/cable_service_screen.dart';
import '../credit_card_view/credit_card_services_screen.dart';
import '../municipal_view/municipal_screen.dart';
import '../broadband_view/broadband_service_screen.dart';
import '../water_view/water_service_screen.dart';
import 'package:jigrotech/View/dashdoard_view/generic_service_form_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.put(AuthController());
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );
  int bannerCurrentIndex = 0;

  Map<int, PageController> pageControllers = {};
  Map<int, int> currentPositions = {};
  PageController controller = PageController(
    viewportFraction: 1,
    keepPage: true,
  );
  int currentPos = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getBannersApi(context: context);
      authController.getProfileApi(context: context);
      notificationController.fetchUnreadNotifications(context);
    });
  }

  void _navigateToService(BuildContext context, String title) {
    String cleanTitle = title.replaceAll('\n', ' ').trim();
    switch (cleanTitle) {
      case "Mobile Recharge":
      case "Postpaid Bill":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileRechargeNumberScreen(),
          ),
        );
        break;
      case "DTH Recharge":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DthServiceScreen()),
        );
        break;
      case "FASTag Recharge":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FastTagScreen()),
        );
        break;
      case "Electricity Bill":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ElectricityBillServiceScreen(),
          ),
        );
        break;
      case "Water Bill":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WaterServiceScreen()),
        );
        break;
      case "Gas Bill":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GasServicesScreen()),
        );
        break;
      case "LPG Gas":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PipedGasServicesScreen(),
          ),
        );
        break;
      case "Broadband Bill":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BroadbandServiceScreen(),
          ),
        );
        break;
      case "Cable TV":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CableServiceScreen()),
        );
        break;
      case "Credit Card":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreditCardServicesScreen(),
          ),
        );
        break;
      case "Loan Repayment":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoanRepaymentScreen()),
        );
        break;
      case "Insurance":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const InsuranceProviderScreen(),
          ),
        );
        break;
      case "Municipal Taxes":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MunicipalServiceScreen(),
          ),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenericServiceFormScreen(title: cleanTitle),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Obx(() {
                  var user = authController.profileData;
                  String? imageUrl =
                      user['profile_image_url']?.toString() ??
                      user['profile_image_url']?.toString();

                  return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: secondaryColor.withValues(alpha: 0.1),
                    ),
                    child: ClipOval(
                      child: (imageUrl != null && imageUrl.startsWith('http'))
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.person,
                                    color: secondaryColor,
                                    size: 24,
                                  ),
                            )
                          : const Icon(
                              Icons.person,
                              color: secondaryColor,
                              size: 24,
                            ),
                    ),
                  );
                }),
                SizedBox(width: 10),
                RichText(
                  text: const TextSpan(
                    text: 'Jigro',
                    style: TextStyle(
                      color: blackColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Pay',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: FontFamily.plusJakartaSansBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              //. Global Search
              IconButton(
                icon: const Icon(
                  IconsaxPlusLinear.search_normal,
                  color: blackColor,
                  size: 26,
                ),
                onPressed: () {
                  Get.to(() => const SearchScreen());
                },
              ),

              //. Notifications
              Obx(() {
                int count = notificationController.unreadCount.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        IconsaxPlusLinear.notification,
                        color: blackColor,
                        size: 26,
                      ),
                      onPressed: () {
                        Get.to(() => const NotificationScreen());
                      },
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: secondaryColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() {
                var banners = authController.bannerList;
                if (authController.isBannerLoading.value) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                }

                String? imgUrl;
                if (banners.isNotEmpty) {
                  var homeBanner = banners.firstWhere(
                    (item) =>
                        item is Map &&
                        (item['title'] == 'Home Banner' || item['order'] == 1),
                    orElse: () => banners.first,
                  );
                  if (homeBanner is Map) {
                    imgUrl =
                        homeBanner['image']?.toString() ??
                        homeBanner['banner_url']?.toString() ??
                        homeBanner['url']?.toString() ??
                        homeBanner['path']?.toString();
                  } else if (homeBanner is String) {
                    imgUrl = homeBanner;
                  }
                }

                return SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: (imgUrl != null && imgUrl.startsWith('http'))
                        ? Image.network(
                            imgUrl,
                            fit: BoxFit.fill,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  AppImages.bannerIcon,
                                  fit: BoxFit.cover,
                                ),
                          )
                        : Image.asset(AppImages.bannerIcon, fit: BoxFit.cover),
                  ),
                );
              }),
              /* SizedBox(height: 20),
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
                        //color: primaryColor
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
              ),*/
              SizedBox(height: 20),
              Card(
                color: white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Recharge & Bills",
                            textColor: blackColor,
                            fontSize: 22,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          // text(
                          //   "View All",
                          //   textColor: secondaryColor,
                          //   fontSize: 12,
                          //   fontFamily: FontFamily.plusJakartaSansBold,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ],
                      ),
                      SizedBox(height: 15),
                      GridView.builder(
                        itemCount: rechargeAndBillList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: .8,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                        itemBuilder: (context, index) {
                          final item = rechargeAndBillList[index];

                          return GestureDetector(
                            onTap: () =>
                                _navigateToService(context, item.title),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Image.asset(item.icon, height: 23),
                                    Icon(item.icon, color: primaryColor),
                                    const SizedBox(height: 6),
                                    text(
                                      item.title,
                                      isCentered: true,
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontSize: 11,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              Obx(() {
                var banners = authController.bannerList;
                if (authController.isBannerLoading.value) {
                  return const SizedBox(
                    height: 180,
                    child: Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                }

                List<dynamic> sliderBanners = [];
                if (banners.isNotEmpty) {
                  sliderBanners = banners.where((item) {
                    if (item is Map) {
                      return item['title'] != 'Home Banner';
                    }
                    return true;
                  }).toList();

                  if (sliderBanners.isEmpty && banners.length > 1) {
                    sliderBanners = banners.sublist(1);
                  }
                }

                int count = sliderBanners.isNotEmpty ? sliderBanners.length : 1;

                return SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      PageView.builder(
                        itemCount: count,
                        controller: PageController(viewportFraction: 1.0),
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (i) {
                          setState(() {
                            bannerCurrentIndex = i;
                          });
                        },
                        itemBuilder: (BuildContext context, itemIndex) {
                          String? imgUrl;
                          if (sliderBanners.isNotEmpty) {
                            var item = sliderBanners[itemIndex];
                            if (item is Map) {
                              imgUrl =
                                  item['image']?.toString() ??
                                  item['banner_url']?.toString() ??
                                  item['url']?.toString() ??
                                  item['path']?.toString();
                            } else if (item is String) {
                              imgUrl = item;
                            }
                          }

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: (imgUrl != null && imgUrl.startsWith('http'))
                                ? Image.network(
                                    imgUrl,
                                    fit: BoxFit.fill,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                              AppImages.bannerIcon,
                                              fit: BoxFit.cover,
                                            ),
                                  )
                                : Image.asset(
                                    AppImages.bannerIcon,
                                    fit: BoxFit.cover,
                                  ),
                          );
                        },
                      ),

                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(count, (index) {
                              return Container(
                                width: bannerCurrentIndex == index ? 20 : 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: bannerCurrentIndex == index
                                      ? primaryColor
                                      : Colors.grey.shade400,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 20),
              Card(
                color: white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Utility Bills",
                            textColor: blackColor,
                            fontSize: 22,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          // text(
                          //   "View All",
                          //   textColor: secondaryColor,
                          //   fontSize: 12,
                          //   fontFamily: FontFamily.plusJakartaSansBold,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ],
                      ),
                      SizedBox(height: 15),
                      GridView.builder(
                        itemCount: utilityBillsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: .8,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                        itemBuilder: (context, index) {
                          final item = utilityBillsList[index];

                          return GestureDetector(
                            onTap: () =>
                                _navigateToService(context, item.title),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item.icon, color: primaryColor),
                                    const SizedBox(height: 6),
                                    text(
                                      item.title,
                                      isCentered: true,
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontSize: 11,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Card(
                color: white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Financial Services",
                            textColor: blackColor,
                            fontSize: 22,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          // text(
                          //   "View All",
                          //   textColor: secondaryColor,
                          //   fontSize: 12,
                          //   fontFamily: FontFamily.plusJakartaSansBold,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ],
                      ),
                      SizedBox(height: 15),
                      GridView.builder(
                        itemCount: financialServicesList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: .8,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                        itemBuilder: (context, index) {
                          final item = financialServicesList[index];

                          return GestureDetector(
                            onTap: () =>
                                _navigateToService(context, item.title),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item.icon, color: primaryColor),
                                    const SizedBox(height: 8),
                                    text(
                                      item.title,
                                      isCentered: true,
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontSize: 13,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: 1,
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
                          child: Image.asset(
                            AppImages.bannerIcon,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                    ),

                    // Page Indicator
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: Align(
                    //     alignment: Alignment.bottomCenter,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(15.0),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: _buildPageIndicator(5),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              Card(
                color: white,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(
                            "Other Services",
                            textColor: blackColor,
                            fontSize: 22,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600,
                          ),

                          // text(
                          //   "View All",
                          //   textColor: secondaryColor,
                          //   fontSize: 12,
                          //   fontFamily: FontFamily.plusJakartaSansBold,
                          //   fontWeight: FontWeight.w400,
                          // ),
                        ],
                      ),
                      SizedBox(height: 15),
                      GridView.builder(
                        itemCount: otherServicesList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: .8,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                        itemBuilder: (context, index) {
                          final item = otherServicesList[index];

                          return GestureDetector(
                            onTap: () =>
                                _navigateToService(context, item.title),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 2,
                                    spreadRadius: 0.5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(item.icon, color: primaryColor),
                                    const SizedBox(height: 6),
                                    text(
                                      item.title,
                                      isCentered: true,
                                      maxLine: 2,
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansMedium,
                                      fontSize: 11,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

class ServiceCategory {
  final String title;
  final IconData icon;

  ServiceCategory({required this.title, required this.icon});
}

final List<ServiceCategory> rechargeAndBillList = [
  // ServiceCategory(title: "Mobile Recharge", icon: AppImages.mobilerechargeIcon),
  // ServiceCategory(title: "DTH Recharge", icon: AppImages.dthRImage),
  // ServiceCategory(title: "FASTag Recharge", icon: AppImages.fastTagImage),
  // ServiceCategory(title: "Electricity Bill", icon: AppImages.electricity1Image),
  // ServiceCategory(title: "Water Bill", icon: AppImages.water1Image),
  // ServiceCategory(title: "Cable TV", icon: AppImages.cableTvImage),
  ServiceCategory(title: "Mobile Recharge", icon: IconsaxPlusLinear.mobile),
  ServiceCategory(title: "DTH Recharge", icon: IconsaxPlusLinear.monitor),
  ServiceCategory(title: "FASTag Recharge", icon: IconsaxPlusLinear.car),
  ServiceCategory(
    title: "Electricity Bill",
    icon: IconsaxPlusLinear.electricity,
  ),
  ServiceCategory(title: "Water Bill", icon: IconsaxPlusLinear.drop),
  ServiceCategory(title: "Cable TV", icon: Icons.cable),
];

final List<ServiceCategory> utilityBillsList = [
  // ServiceCategory(title: "Broadband Bill", icon: AppImages.boradImage),
  // ServiceCategory(title: "Gas Bill", icon: AppImages.lpgGasImage),
  // ServiceCategory(title: "LPG Gas", icon: AppImages.lpgGasImage),
  ServiceCategory(title: "Broadband Bill", icon: IconsaxPlusLinear.wifi),
  ServiceCategory(title: "Gas Bill", icon: Icons.fire_hydrant_alt),
  ServiceCategory(title: "LPG Gas", icon: Icons.fire_hydrant_alt),
];

final List<ServiceCategory> financialServicesList = [
  // ServiceCategory(title: "Credit Card", icon: AppImages.crCardImage),
  // ServiceCategory(title: "Loan Repayment", icon: AppImages.loanReImage),
  // ServiceCategory(title: "Insurance", icon: AppImages.insuImage),
  ServiceCategory(title: "Credit Card", icon: IconsaxPlusLinear.card),
  ServiceCategory(title: "Loan Repayment", icon: Icons.money),
  ServiceCategory(title: "Insurance", icon: IconsaxPlusLinear.document),
];

final List<ServiceCategory> otherServicesList = [
  ServiceCategory(title: "Municipal Taxes", icon: IconsaxPlusLinear.building),
  // ServiceCategory(title: "PAN Services", icon: IconsaxPlusLinear.card),
  // ServiceCategory(title: "Municipal Taxes", icon: IconsaxPlusLinear.building),
  ServiceCategory(title: "PAN Services", icon: IconsaxPlusLinear.card),
];
