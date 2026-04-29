
import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'hotel_room_details_screen.dart';

class HotelDetailsScreen extends StatefulWidget{
  const HotelDetailsScreen({super.key});
  @override

  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen>with SingleTickerProviderStateMixin{
  late TabController _tabController;
  int? selectedRoomIndex;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
            ),
            Expanded(
              child: text("New Delhi, India",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:white,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
            ),


            // SizedBox(width: 10,),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:greenColor
              ),
              child: Row(
                children: [
                  Expanded(
                    child: text(
                      "₹100 Instant Discount Applied",
                      textColor: lightGreenColor,
                      isCentered: true,
                      textAlign: TextAlign.center,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                      maxLine: 2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  "₹836",
                  textColor: lightGreenColor,
                  isCentered: true,
                  textAlign: TextAlign.center,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w400,
                  maxLine: 2,
                ),
                SizedBox(
                  height: 55,
                  child: CommonButton(
                      text: "Continue",
                      textColor: white,
                      gradient: const LinearGradient(
                        colors: [pinkColor, purpleGradientColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontSize:16.0,
                      //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      //borderRadius: BorderRadius.circular(40.0),

                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HotelRoomDetailsScreen(),));
                      }



                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppImages.hotelElevationImage),
          const SizedBox(height: 10),
          text("Super Hotel O Adipur Narela",
              textColor: blackColor,
              fontSize: 18,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600),
          Row(
            children: [
              text("view map",
                  textColor: blackColor,
                  fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w300),
              Icon(Icons.star, color: lightGreenColor),
              Icon(Icons.check, color: lightGreenColor),
            ],
          ),
          const SizedBox(height: 10),
          Card(
            color: white,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 5),
                    text("13 Oct 2025 - 14 Oct 2025",
                        textColor: blackColor,
                        fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansRegular),
                  ]),
                  Row(children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 5),
                    text("2 Guests, 1 Room",
                        textColor: blackColor,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansRegular),
                  ]),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: pinkColor),
                  ),
                  unselectedLabelColor: greyColor,
                  labelColor: pinkColor,
                  tabs: const [
                    Tab(text: 'Rooms'),
                    Tab(text: 'Overview'),
                    Tab(text: 'Details'),
                  ],
                ),
                // 🧩 Use SizedBox instead of Expanded
                SizedBox(
                  height: MediaQuery.sizeOf(context).height*.3, // fixed or MediaQuery height
                  child: TabBarView(
                    controller: _tabController,
                    children:  [
                      //SizedBox(height: 10,),
                      SingleChildScrollView(
                        child: Expanded(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: yellowColor,
                                ),
                                child: text(
                                  "Get flat ₹1000 Cashback on booking above ₹5,000",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansBold,
                                  fontWeight: FontWeight.w400,
                                  maxLine: 2,
                                ),
                              ),
                              SizedBox(height: 15,),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              text(
                                                "Classic Room",
                                                textColor: blackColor,
                                                fontSize: 14,
                                                fontFamily: FontFamily.plusJakartaSansBold,
                                                fontWeight: FontWeight.w400,
                                                maxLine: 2,
                                              ),
                                              text(
                                                "View More Details",
                                                textColor: blueColor,
                                                fontSize: 14,
                                                fontFamily: FontFamily.plusJakartaSansBold,
                                                fontWeight: FontWeight.w400,
                                                maxLine: 2,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Image.asset(AppImages.roomImage),
                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Radio<int>(
                                                value: index,
                                                groupValue: selectedRoomIndex,
                                                activeColor: Colors.blue, // change color as you like
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedRoomIndex = value;
                                                  });
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "Classic Room With Free Upgraded Breakfast",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                  Row(
                                                    children: [
                                                      text(
                                                        "Bed and Breakfast",
                                                        textColor: blackColor,
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.plusJakartaSansMedium,
                                                        fontWeight: FontWeight.w500,
                                                        maxLine: 2,
                                                      ),
                                                      text(
                                                        "Free Wi-Fi",
                                                        textColor: blackColor,
                                                        fontSize: 14,
                                                        fontFamily: FontFamily.plusJakartaSansMedium,
                                                        fontWeight: FontWeight.w500,
                                                        maxLine: 2,
                                                      ),
                                                    ],
                                                  ),
                                                  text(
                                                    "Complimentary stay for child under 5 year old",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                  text(
                                                    "₹836",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansBold,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Radio<int>(
                                                value: index,
                                                groupValue: selectedRoomIndex,
                                                activeColor: Colors.blue, // change color as you like
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedRoomIndex = value;
                                                  });
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "Breakfast not included",
                                                    textColor: blackColor,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                  text(
                                                    "Complimentary stay for child under 5 year old",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                  text(
                                                    "₹836",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansBold,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              Radio<int>(
                                                value: index,
                                                groupValue: selectedRoomIndex,
                                                activeColor: Colors.blue, // change color as you like
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedRoomIndex = value;
                                                  });
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  text(
                                                    "Room With Breakfast",
                                                    textColor: blackColor,
                                                    fontSize: 14,
                                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                  text(
                                                    "Complimentary stay for child under 5 year old",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                  text(
                                                    "₹1,041",
                                                    textColor: blackColor,
                                                    fontSize: 13,
                                                    fontFamily: FontFamily.plusJakartaSansBold,
                                                    fontWeight: FontWeight.w500,
                                                    maxLine: 2,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                              },),
                              SizedBox(height: 15,),

                            ],
                          ),
                        ),
                      ),
                      Center(child: Text('Insurance Tab Content')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

            ),
    );
  }
}