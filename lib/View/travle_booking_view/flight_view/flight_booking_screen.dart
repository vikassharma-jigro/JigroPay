import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/search_flight_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class FlightBookingScreen extends StatefulWidget{
  const FlightBookingScreen({super.key});
  @override

  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen>{
  bool isChecked = false;

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
             text("JigroPay",
                 textAlign: TextAlign.center,
                 isCentered: true,
                 textColor:white,fontSize: 18,
                 fontFamily: FontFamily.plusJakartaSansBold,
                 fontWeight: FontWeight.w600),

             Container(
               padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 border: Border.all(color: white)
               ),
               child: text("About",
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
     body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(16.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Center(
                   child: text("Book Flights with",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:blackColor,fontSize: 18,
                       fontFamily: FontFamily.plusJakartaSansRegular,
                       fontWeight: FontWeight.w400),
                 ),
                 SizedBox(width: 4,),
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                       color: orangeColor
                   ),
                   child: text("ixigo",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:white,fontSize: 18,
                       fontFamily: FontFamily.plusJakartaSansBold,
                       fontWeight: FontWeight.w600),
                 ),
               ],
             ),
             SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                       color: lightGreyColor
                   ),
                   child: text("One Way",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:blackColor,fontSize: 18,
                       fontFamily: FontFamily.plusJakartaSansMedium,
                       fontWeight: FontWeight.w500),
                 ),

                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(15),
                     border: Border.all(color: lightGreyColor),

                   ),
                   child: text("Round Trip",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:blackColor,fontSize: 18,
                       fontFamily: FontFamily.plusJakartaSansRegular,
                       fontWeight: FontWeight.w400),
                 ),
               ],
             ),
             SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Row(
                   children: [
                     Image.asset(AppImages.pleanImage,height: 30,),
                     SizedBox(width: 10,),
                     text("From",
                         textAlign: TextAlign.center,
                         isCentered: true,
                         textColor:greyColor,fontSize: 18,
                         fontFamily: FontFamily.plusJakartaSansRegular,
                         fontWeight: FontWeight.w400),
                   ],
                 ),

                 Row(
                   children: [

                     text("To",
                         textAlign: TextAlign.center,
                         isCentered: true,
                         textColor:greyColor,fontSize: 18,
                         fontFamily: FontFamily.plusJakartaSansRegular,
                         fontWeight: FontWeight.w400),
                     SizedBox(width: 10,),
                     Image.asset(AppImages.pleanImage,height: 30,),

                   ],
                 ),
               ],
             ),
             SizedBox(height: 10,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 text("Enter Origin",
                     textAlign: TextAlign.center,
                     isCentered: true,
                     textColor:greyColor,fontSize: 16,
                     fontFamily: FontFamily.plusJakartaSansRegular,
                     fontWeight: FontWeight.w400),

                 text("Enter Destination",
                     textAlign: TextAlign.center,
                     isCentered: true,
                     textColor:greyColor,fontSize: 16,
                     fontFamily: FontFamily.plusJakartaSansRegular,
                     fontWeight: FontWeight.w400),
               ],
             ),
             SizedBox(height: 20,),
             Row(
               children: [
                 Icon(Icons.calendar_month,color: greyColor),
                 SizedBox(width: 10,),
                 text("Mon, 13 Oct",
                     textAlign: TextAlign.center,
                     isCentered: true,
                     textColor:blackColor,fontSize: 16,
                     fontFamily: FontFamily.plusJakartaSansBold,
                     fontWeight: FontWeight.w400),
               ],
             ),
             SizedBox(height: 20,),
             Row(
               children: [
                 Icon(Icons.person,color: greyColor,),
                 SizedBox(width: 10,),
                 text("1 Traveller • Economy",
                     textAlign: TextAlign.center,
                     isCentered: true,
                     textColor:blackColor,fontSize: 16,
                     fontFamily: FontFamily.plusJakartaSansBold,
                     fontWeight: FontWeight.w400),


               ],
             ),
             SizedBox(height: 15,),
             text("Special Fares (Optional)",
                 textAlign: TextAlign.center,
                 isCentered: true,
                 textColor:greyColor,fontSize: 16,
                 fontFamily: FontFamily.plusJakartaSansMedium,
                 fontWeight: FontWeight.w400),
             SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                       color: lightGreyColor
                   ),
                   child: text("Student",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:blackColor,fontSize: 14,
                       fontFamily: FontFamily.plusJakartaSansMedium,
                       fontWeight: FontWeight.w500),
                 ),

                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                       color: lightGreyColor

                   ),
                   child: text("Senior Citizen",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:blackColor,fontSize: 14,
                       fontFamily: FontFamily.plusJakartaSansMedium,
                       fontWeight: FontWeight.w500),
                 ),

                 Container(
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7),
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(15),
                       color: lightGreyColor

                   ),
                   child: text("Armed Forces",
                       textAlign: TextAlign.center,
                       isCentered: true,
                       textColor:blackColor,fontSize: 14,
                       fontFamily: FontFamily.plusJakartaSansMedium,
                       fontWeight: FontWeight.w500),
                 ),
               ],
             ),
             SizedBox(height: 20,),
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
                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                     visualDensity: VisualDensity.compact,
                     side: const BorderSide(color: purpleGradientColor,width: 1)
                 ),

                 SizedBox(width: 10,),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     text("Always opt for Assured",
                         textColor: blackColor,fontFamily: FontFamily.plusJakartaSansMedium,
                         fontSize: 16,fontWeight: FontWeight.w500,
                         maxLine: 3
                     ),text("₹0 cancellation fee",
                         textColor: greyColor,fontFamily: FontFamily.plusJakartaSansMedium,
                         fontSize: 16,fontWeight: FontWeight.w500,
                         maxLine: 3
                     ),

                   ],
                 )
               ],
             ),
             SizedBox(height: 20,),
             InkWell(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context) => SearchFlightScreen(),));
               },
               child: Container(
                 width: MediaQuery.sizeOf(context).width,
                 padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10),
                   gradient: LinearGradient(
                     colors: [lightBtnColor, lightBtn1Color],
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                   ),
                 ),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.search,color: white,),
                     text("Search Flights",
                         textColor: white,fontFamily: FontFamily.plusJakartaSansBold,
                         fontSize: 18,fontWeight: FontWeight.w600,
                         maxLine: 3
                     ),
                   ],
                 ),
               ),
             ),
             SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   children: [
                     SvgPicture.asset(AppImages.bookingImage),
                     SizedBox(height: 5,),
                     text("My Bookings",
                         textColor: blackColor,fontFamily: FontFamily.plusJakartaSansRegular,
                         fontSize: 16,fontWeight: FontWeight.w400,
                         maxLine: 3
                     ),
                   ],
                 ),
                 Column(
                   children: [
                     SvgPicture.asset(AppImages.supportImage),
                     SizedBox(height: 5,),
                     text("Customer Support",
                         textColor: blackColor,fontFamily: FontFamily.plusJakartaSansRegular,
                         fontSize: 16,fontWeight: FontWeight.w400,
                         maxLine: 3
                     ),
                   ],
                 ),
                 Column(
                   children: [
                     SvgPicture.asset(AppImages.ixMoneyImage),
                     SizedBox(height: 5,),
                     text("ixigo Money",
                         textColor: blackColor,fontFamily: FontFamily.plusJakartaSansRegular,
                         fontSize: 16,fontWeight: FontWeight.w400,
                         maxLine: 3
                     ),
                   ],
                 )
               ],
             ),
             SizedBox(height: 20,),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 text("Today's Flight Offers",
                     textColor: blackColor,fontFamily: FontFamily.plusJakartaSansBold,
                     fontSize: 18,fontWeight: FontWeight.w600,
                     maxLine: 3
                 ),

                 Row(
                   children: [
                     text("View All",
                         textColor: blue1Color,fontFamily: FontFamily.plusJakartaSansRegular,
                         fontSize: 14,fontWeight: FontWeight.w400,
                         maxLine: 3
                     ),
                     SizedBox(width: 10,),
                     Icon(Icons.arrow_forward_ios,size: 20,color: blue1Color,),
                   ],
                 ),
               ],
             ),
           ],
         )
       ),
     ),
   );
  }
}