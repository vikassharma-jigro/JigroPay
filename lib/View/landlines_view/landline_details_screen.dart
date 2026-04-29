
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';



class LandlineDetailsScreen extends StatefulWidget {
  final String? serviceNo;

  const LandlineDetailsScreen({super.key,this.serviceNo});

  @override
  State<LandlineDetailsScreen> createState() => _LandlineDetailsScreenState();
}


class _LandlineDetailsScreenState extends State<LandlineDetailsScreen> {
  TextEditingController mobileNumberController = TextEditingController();
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
            text(widget.serviceNo??"",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomRoundTextField(
                controller:mobileNumberController,
                keyboardType: TextInputType.phone,
                hintText: "Telephone Number",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10),],
              ),

              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  showDialogBox(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lightBlueColor
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 10,),
                          text("View Sample Bill",
                              textColor: blackColor,
                              fontWeight: FontWeight.w400,fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansRegular
                          )
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),

                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),
              text("We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
                  textColor: greyColor,
                  fontWeight: FontWeight.w400,fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular
              )
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
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
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
                  height: 180,
                  width: 300,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(height: 30,),
                        text("BSNL",
                            textColor:red1Color,fontSize: 18,
                            textAlign: TextAlign.center,
                            isCentered: true,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),

                        text("Connecting India",
                            textColor:blueColor,fontSize: 15,
                            textAlign: TextAlign.center,
                            isCentered: true,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500),

                        SizedBox(height: 10,),
                        text("Telephone Number- 7865984537",
                            textColor:blackColor,fontSize: 16,
                            textAlign: TextAlign.center,
                            isCentered: true,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),
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
                    Navigator.pop(context);
                  }



              ),
            ),
          ],
        ),
      ),
    );
  }
}




