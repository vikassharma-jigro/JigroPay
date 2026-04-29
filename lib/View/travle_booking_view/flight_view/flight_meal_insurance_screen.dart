import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_colors.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/font_family.dart';

import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class AddOnsMealScreen extends StatefulWidget {
  const AddOnsMealScreen({super.key});

  @override
  State<AddOnsMealScreen> createState() => _AddOnsMealScreenState();
}

class _AddOnsMealScreenState extends State<AddOnsMealScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool vegOnly = false;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            text(
              "Add-ons",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: white,
              fontSize: 18,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
            ),

            text(
              "Skip to Pay",
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: white,
              fontSize: 14,
              fontFamily: FontFamily.plusJakartaSansRegular,
              fontWeight: FontWeight.w400,
            ),

            // SizedBox(width: 10,),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTabController(
          length: 2, // Specify the number of tabs here
          child: Column(
            children: [
              TabBar(
                isScrollable: false,
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: blueColor),
                  //insets: EdgeInsets.symmetric(horizontal:22.0)
                ),
                unselectedLabelColor: pinkColor,
                indicatorPadding: const EdgeInsets.only(left: 10, right: 10),
                labelColor: blueColor,
                labelStyle: TextStyle(
                  color: blueColor,
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w400,
                ),
                tabs: const [
                  Tab(text: 'Meal'),
                  Tab(text: 'Insurance'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Veg only",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value: vegOnly,
                              activeColor: const Color(0xff6E2AE9),
                              onChanged: (v) => setState(() => vegOnly = v),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              buildMealCard(
                                "Cucumber Tomato Cheese and Lettuce Sandwich + beverage",
                                "₹425",
                              ),
                              buildMealCard(
                                "6E Eats choice of the day (non-veg) + beverage",
                                "₹525",
                              ),
                              buildMealCard("Fruit Cake", "₹225"),
                              buildMealCard(
                                "Diabetic veg meal + beverage",
                                "₹425",
                              ),
                              buildMealCard(
                                "Chicken Junglee Sandwich + beverage",
                                "₹525",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    Column(
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                              colors: [blue1Color, yellowColor],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            children: [
                              text(
                                "Protect your trip plans",
                                textColor: white,
                                fontSize: 15,
                                fontFamily: FontFamily.plusJakartaSansBold,
                              ),
                            ],
                          ),
                        ),
                        Card(
                          color: white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    text(
                                      "Travel Insurance",
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),

                                    text(
                                      "Reliance General Insurance",
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansRegular,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    text(
                                      "Benefits",
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),

                                    text(
                                      "View All >",
                                      textColor: pinkColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansRegular,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.bookingImage,
                                        ),
                                        text(
                                          "Lost Baggage",
                                          textColor: greyColor,
                                          fontFamily:
                                              FontFamily.plusJakartaSansRegular,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        text(
                                          "Up to ₹10,000",
                                          textColor: blackColor,
                                          fontFamily:
                                              FontFamily.plusJakartaSansBold,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Image.asset(
                                          AppImages.pleanImage,
                                          height: 20,
                                        ),
                                        text(
                                          "Trip Cancellation",
                                          textColor: greyColor,
                                          fontFamily:
                                              FontFamily.plusJakartaSansRegular,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        text(
                                          "Up to ₹9,000",
                                          textColor: blackColor,
                                          fontFamily:
                                              FontFamily.plusJakartaSansBold,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                          AppImages.bookingImage,
                                        ),
                                        text(
                                          "Trip Delay",
                                          textColor: greyColor,
                                          fontFamily:
                                              FontFamily.plusJakartaSansRegular,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        text(
                                          "Up to ₹9,000",
                                          textColor: blackColor,
                                          fontFamily:
                                              FontFamily.plusJakartaSansBold,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    text(
                                      "₹149 per traveller",
                                      textColor: blackColor,
                                      fontFamily:
                                          FontFamily.plusJakartaSansBold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xff6E2AE9),
                                            Color(0xffC882FD),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.0,
                                          vertical: 6.0,
                                        ),
                                        child: Text(
                                          "Add",
                                          style: TextStyle(
                                            color: blackColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                          print("hhh>>>$isChecked");
                                        });
                                      },
                                      activeColor: purpleGradientColor,
                                      //checkColor: Colors.white,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                      side: const BorderSide(
                                        color: purpleGradientColor,
                                        width: 1,
                                      ),
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        text:
                                            'I confirm that all travellers are under 70 years of\nage at the time of travel & I agree to the Good \nHealth Terms and the T&C',
                                        style: TextStyle(
                                          color: blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontFamily:
                                              FontFamily.plusJakartaSansRegular,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: 'Sign Up',
                                            style: TextStyle(
                                              color: pinkColor,
                                              fontSize: 14,
                                              fontFamily: FontFamily
                                                  .plusJakartaSansRegular,
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "₹7,289",
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  text(
                    "₹6,964",
                    fontFamily: FontFamily.plusJakartaSansBold,
                    textColor: blackColor,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {},
                child: Ink(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xff6E2AE9), Color(0xffC882FD)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Pay",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealCard(String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(
                  title,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  textColor: blackColor,
                  fontSize: 14,
                  maxLine: 2,
                ),
                text(
                  price,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  textColor: blackColor,
                  fontSize: 14,
                  maxLine: 2,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff6E2AE9), Color(0xffC882FD)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 6.0,
                  ),
                  child: Text(
                    "Add",
                    style: TextStyle(
                      color: blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
