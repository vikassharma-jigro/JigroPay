import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/travle_booking_view/bus_view/search_bus_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/app_images.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class BusBookingPointScreen extends StatefulWidget {
  const BusBookingPointScreen({super.key});

  @override
  State<BusBookingPointScreen> createState() => _BusBookingPointScreenState();
}


class _BusBookingPointScreenState extends State<BusBookingPointScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  int? isSelected;
  List<Map<String, dynamic>> allDate = [
    {"name": "Sun", "date": "12",},
    {"name": "Mon", "date": "13",},
    {"name": "Tue", "date": "14",},
    {"name": "Wed", "date": "15",},
    {"name": "Thu", "date": "16",},
    {"name": "Fri", "date": "17",},
    {"name": "Sat", "date": "18",},
  ];
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
            text("Jigropay",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor:white,fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600),
            Icon(Icons.help),

            // SizedBox(width: 10,),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: RichText(
                  text:  TextSpan(
                    text: 'abhibus ',
                    style:  TextStyle(color: red1Color,fontSize:18,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w500
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'on ',
                        style:  TextStyle(color: greyColor,fontSize:15 ,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w400
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {

                          },
                      ),
                      TextSpan(
                        text: 'Jigropay ',
                        style:  TextStyle(color: purpleGradientColor,fontSize:18 ,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {

                          },
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: green1Color
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text("Trusted by 5 crore+ Indian travellers",
                    isCentered: true,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                      fontSize: 14,fontWeight: FontWeight.w500,textColor: white
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: pinkColor.withOpacity(.3)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star,color: purpleGradientColor,),
                    text("Save upto ₹300* on Bus Bookings",
                        isCentered: true,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontSize: 14,fontWeight: FontWeight.w500,textColor: purpleGradientColor
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),

              Card(
                color: white,
                child:   Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CustomRoundTextField(
                        controller:fromController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Image.asset(AppImages.pleanImage,height: 5,),
                        ),
                       // keyboardType: TextInputType.phone,
                        hintText: "Leaving From",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),

                      CustomRoundTextField(
                        controller:toController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.location_on,color: greyColor,),
                        ),
                        //keyboardType: TextInputType.n,
                        hintText: "Going To",
                        maxLines: 2,
                        fillColor: Colors.transparent,
                        //padding: const EdgeInsets.symmetric(vertical: 2),
                        inputFormatters: [LengthLimitingTextInputFormatter(10),],
                      ),
                      SizedBox(height: 15,),
                      SizedBox(
                        height: 60,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: allDate.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            bool isSelectedColor = isSelected==index;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    isSelected = index;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  color: isSelectedColor?lightBlueColor:Colors.transparent,
                                  child: Column(
                                    children: [
                                      text(allDate[index]["name"],
                                          textAlign: TextAlign.center,
                                          isCentered: true,
                                          textColor:isSelectedColor?blue1Color:greyColor,fontSize: 14,
                                          fontFamily: FontFamily.plusJakartaSansRegular,
                                          fontWeight: FontWeight.w400),
                                      text(allDate[index]["date"],
                                          textAlign: TextAlign.center,
                                          isCentered: true,
                                          textColor:isSelectedColor?blue1Color:greyColor,fontSize: 14,
                                          fontFamily: FontFamily.plusJakartaSansRegular,
                                          fontWeight: FontWeight.w400),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },),
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 55,
                        child: CommonButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchBusScreen(),));
                          },
                          text: "Search Buses",
                          gradient: const LinearGradient(
                            colors: [pinkColor, purpleGradientColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          textColor: white,
                          fontWeight: FontWeight.w500,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize:18.0,
                          //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                          borderRadius: BorderRadius.circular(15.0),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: pinkColor.withOpacity(.3),
                ),
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text("Login & Get up to ₹300* off on your Bus Booking !",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w400),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:white,
                      ),
                      child:  text("Login Now",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text("Bus Booking Discount Offers",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor:blackColor,fontSize: 15,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600),

                  text("View All",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor:purpleGradientColor,fontSize: 15,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontWeight: FontWeight.w600),
                ],
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: orangeColor,
                ),
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        text("Upto ₹300* Off",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:white,fontSize: 15,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                    text("on bus bookings",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:white,fontSize: 15,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600),

                  ],
                ),
              ),
            ],
          )
        ),
      ),



    );
  }
}




