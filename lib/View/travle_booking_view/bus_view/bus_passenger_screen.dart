import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/travle_booking_view/bus_view/bus_ticket_pay_screen.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/flight_travle_form_screen.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/app_images.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class BusPassengerScreen extends StatefulWidget{
  const BusPassengerScreen({super.key});
  @override

  State<BusPassengerScreen> createState() => _BusPassengerScreenState();
}

class _BusPassengerScreenState extends State<BusPassengerScreen>{
TextEditingController emailController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController ageController = TextEditingController();
TextEditingController phoneController = TextEditingController();
bool? isSelectedGender;
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
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
            ),
            Expanded(
              child: text("Passenger Details",
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
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text("₹800.00",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor:blackColor,fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w500),
                text("Excl of taxes • 1 Seat(s)",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor:blackColor,fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w500),
              ],
            ),
            SizedBox(
              height: 55,
              child: CommonButton(
                  text: "Proceed",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BusTicketPayScreen(),));
                  }
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("1 Traveller • Wed, 15 Oct",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                      Row(
                        children: [


                          text("JAI",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor:blackColor,fontSize: 18,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w600),
                          Icon(Icons.arrow_forward,color: blackColor,),
                          text("DEL",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor:blackColor,fontSize: 18,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                      text("Gajraj Travels (Bharat Benz AC Sleeper",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Contact Details",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w500),

                      text("Your Ticket and Bus Info will be sent here",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                      SizedBox(height: 15,),
                      CustomRoundTextField(
                        controller:emailController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(AppImages.emailIcon,height: 10,),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Email Id",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                      ),

                      SizedBox(height: 15,),
                      CustomRoundTextField(
                        controller:phoneController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(AppImages.phoneIcon,height: 10,),
                        ),
                        keyboardType: TextInputType.phone,
                        hintText: "Phone",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Passenger Details",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 18,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontWeight: FontWeight.w500),

                      text("Fill passenger details corresponding to the seats",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                      SizedBox(height: 15,),
                      CustomRoundTextField(
                        controller:nameController,

                        keyboardType: TextInputType.name,
                        hintText: "Name",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(20),],
                      ),

                      SizedBox(height: 15,),
                      CustomRoundTextField(
                        controller:ageController,

                        keyboardType: TextInputType.phone,
                        hintText: "Age",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),
                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSelectedGender = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isSelectedGender==true?lightorangeColor:white,
                                    border: Border.all(color: pinkColor)
                                ),
                                child: text("Male",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor:blackColor,fontSize: 16,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),

                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  isSelectedGender = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:  isSelectedGender == true?white:lightorangeColor,
                                    border: Border.all(color: pinkColor)
                                ),
                                child: text("Female",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor:blackColor,fontSize: 16,
                                    fontFamily: FontFamily.plusJakartaSansRegular,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 15,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text("Billing Address",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor:blackColor,fontSize: 18,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w500),
                          Icon(Icons.edit,color: purpleGradientColor,),
                        ],
                      ),

                      text("(for GST tax invoice)",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                      SizedBox(height: 10,),
                      text("Nimla Bhawan, Ajmeri Pulliya Jaipur, Jaipur,Rajasthan 302001",
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}