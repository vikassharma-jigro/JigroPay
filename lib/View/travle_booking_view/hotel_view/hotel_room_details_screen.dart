
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'hotel_order_histroy_screen.dart';

class HotelRoomDetailsScreen extends StatefulWidget{
  const HotelRoomDetailsScreen({super.key});
  @override

  State<HotelRoomDetailsScreen> createState() => _HotelRoomDetailsScreenState();
}

class _HotelRoomDetailsScreenState extends State<HotelRoomDetailsScreen>{
  int? selectedRoomIndex;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  bool isChecked = false;
  bool isCheckedGst = false;
  @override
  void initState() {
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
                      text: "Continue Booking",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HotelOrderHistoryScreen(),));
                      }



                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text("Super Hotel O Adipur Narela",
                  textColor: blackColor,
                  fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),

              text("Adipur dhand",
                  textColor: blackColor,
                  fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w600),

              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                       Image.asset(AppImages.roomImage,height: 50,),
                        const SizedBox(width: 10),
                        text("Classic Room",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium),
                      ]),
                      SizedBox(height: 10,),
                      text("Bed and breakfast",
                          textColor: blackColor,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansMedium),
                      text("Free Wi-Fi",
                          textColor: greyColor,
                          fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular),
                      text("Complimentary stay for child under 5 year old",
                          textColor: greyColor,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansRegular),
                      SizedBox(height: 10,),
                      text("Check-In 13 Oct 2025 12:00 PM",
                          textColor: greyColor,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansRegular),
                      text("Check-Out 14 Oct 2025 11:00 AM",
                          textColor: greyColor,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansRegular),

                      text("1 night 2 Days • 1 Room • 2 Guests",
                          textColor: greyColor,
                          fontSize: 16,
                          fontFamily: FontFamily.plusJakartaSansRegular),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Price Breakup",
                          textColor: blackColor,
                          fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("1 Room, 1 Night",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),

                          text("₹ 2,341",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Hotel Discount",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),

                          text("- ₹ 1,593",
                              textColor: red1Color,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Price After Discount",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),

                          text("₹ 748",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Taxes and Fees",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),

                          text("₹138",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Coupon Applied",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),

                          text("- ₹10.0",
                              textColor: red1Color,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(thickness: .5,color: greyColor,),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Grand Total",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansBold),

                          text("₹886",
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansBold),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          text("Traveller Details",
                              textColor: blackColor,
                              fontSize: 18,
                              fontFamily: FontFamily.plusJakartaSansBold),
                        ],
                      ),

                      text("Enter your details per your Govt ID proof",
                          textColor: blackColor,
                          fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular),
                      SizedBox(height: 10,),
                      CustomRoundTextField(
                        controller:firstNameController,
                        keyboardType: TextInputType.name,
                        hintText: "First Name",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        //inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),

                      SizedBox(height: 10,),
                      CustomRoundTextField(
                        controller:lastNameController,
                        keyboardType: TextInputType.name,
                        hintText: "Last Name",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        //inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),

                      SizedBox(height: 10,),
                      CustomRoundTextField(
                        controller:emailController,
                        keyboardType: TextInputType.name,
                        hintText: "Email Address",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        //inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),

                      SizedBox(height: 10,),
                      CustomRoundTextField(
                        controller:mobileNumberController,
                        keyboardType: TextInputType.number,
                        hintText: "Mobile Number",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),
                    ],
                  ),
                ),
              ),


              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Offers and Promo Codes",
                              textColor: blackColor,
                              fontSize: 18,
                              fontFamily: FontFamily.plusJakartaSansBold),

                          text("Claim >",
                              textColor: blueColor,
                              fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansRegular),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:yellowColor.withOpacity(.3)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: text(
                                "Get flat ₹500 Cashback on booking above",
                                textColor: blackColor,
                                isCentered: true,
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                                maxLine: 2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: greyColor)
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                text(
                                  "EMTPHONEPE",
                                  textColor: blackColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansMedium,
                                  fontWeight: FontWeight.w400,
                                  maxLine: 2,
                                ),
                                text(
                                  "Remove",
                                  textColor: red1Color,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansMedium,
                                  fontWeight: FontWeight.w400,
                                  maxLine: 2,
                                ),
                              ],
                            ),
                            text(
                              "Flat ₹10.0 Instant Discount of Rs. 10.0 has been applied successfully.",
                              textColor: lightGreenColor,
                              fontSize: 12,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                              maxLine: 2,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:blue1Color
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: text(
                                "EMT PHONEPE - Get Rs. 210.0 Off on hotel booking",
                                textColor: white,
                                isCentered: true,
                                textAlign: TextAlign.center,
                                fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400,
                                maxLine: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      text(
                        "View More Coupons",
                        textColor: blueColor,
                        isCentered: true,
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400,
                        maxLine: 2,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:greenColor
                ),
                child: Column(
                  children: [
                    text(
                      "Help us preserve India's Heritage & Green Spaces!",
                      textColor: lightGreenColor,
                      isCentered: true,
                      textAlign: TextAlign.center,
                      fontSize: 14,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w400,
                      maxLine: 2,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: white
                          ),
                         child:text(
                            "₹10",
                            textColor: lightGreenColor,
                            isCentered: true,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                        ), Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: white
                          ),
                         child:text(
                            "₹20",
                            textColor: lightGreenColor,
                            isCentered: true,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                        ), Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: white
                          ),
                         child:text(
                            "₹30",
                            textColor: lightGreenColor,
                            isCentered: true,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                        ),Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: white
                          ),
                         child:text(
                            "₹40",
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
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              checkColor: Colors.white,
                              value: isCheckedGst,
                              onChanged: (bool? value) {
                                setState(() {
                                  isCheckedGst = value!;
                                  print("hhh>>>$isCheckedGst");
                                });
                              },
                              activeColor: purpleGradientColor,
                              //checkColor: Colors.white,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              side: const BorderSide(color: purpleGradientColor,width: 1)
                          ),

                          text(
                            "Use GST for this booking (Optional)",
                            textColor: blackColor,
                            isCentered: true,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
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
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              side: const BorderSide(color: purpleGradientColor,width: 1)
                          ),

                          text(
                            "I accept T&C and Privacy Policy",
                            textColor: blackColor,
                            isCentered: true,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w400,
                            maxLine: 2,
                          ),
                        ],
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
}