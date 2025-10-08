
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';



class DthCustomerScreen extends StatefulWidget {

  const DthCustomerScreen({super.key,});

  @override
  State<DthCustomerScreen> createState() => _DthCustomerScreenState();
}


class _DthCustomerScreenState extends State<DthCustomerScreen> {
  TextEditingController customerController = TextEditingController();
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
              child: text("DTH",
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(AppImages.sunImage,color: red1Color,),
              ],
            ),
              SizedBox(height: 15),
              text("Enter your Customer Id to retrieve your account details.",
                  textColor:blackColor,fontSize: 20,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
              SizedBox(height: 15),
              Form(
                //key: _formKey,
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Customer Id",
                      hintStyle: TextStyle(color: greyColor,fontSize: 14,fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansRegular),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyColor,),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyColor),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: customerController,
                    style: const TextStyle(color: blackColor,fontSize: 16,fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansMedium),
                  ),
                ),
              ),

              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: pinkColor),
                  borderRadius: BorderRadius.circular(10),
                  color: lightPinkColor
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(

                      children: [
                        Icon(Icons.copy),
                        SizedBox(width: 15,),
                        text("View Sample Bill",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:pinkColor,fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios),

                  ],
                ),
              ),

              SizedBox(height: 50,),
              text("We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:greyColor,fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w600),

              const SizedBox(height: 50,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
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
                      showDialogBox(context);
                    }



                ),
              ),
            ],
          ),
        ),
      ),



    );
  }
  void showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             text("View Sample Bill",textColor: blackColor,fontSize: 18,
             fontWeight: FontWeight.w600,fontFamily: FontFamily.plusJakartaSansBold
             ),
            Icon(Icons.close),
          ],
        ),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                color: greyColor, // ✅ defined here, not inside Container
                strokeWidth: 2,
                dashPattern: [6, 3],
                child: Container(
                  height: 170,
                  width: 300,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(AppImages.sunImage),
                            text(
                              "AIRTEL",
                              textColor: blackColor,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontSize: 14
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        text(
                            "AIRTEL DTH",
                            textColor: blackColor,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 14
                        ),
                        text(
                            "DTH RECHARGE",
                            textColor: greyColor,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontSize: 14
                        ),
                        SizedBox(height: 10,),
                        Divider(
                          thickness: .5,color: greyColor,height: 10,
                        ),
                        SizedBox(height: 10,),
                        text("Customer Id: 1598745630*",
                            textColor:blackColor,fontSize: 14,
                            textAlign: TextAlign.center,
                            isCentered: true,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50,),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                  text: "Got it",
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

                  }



              ),
            ),
          ],
        ),
      ),
    );
  }
}




