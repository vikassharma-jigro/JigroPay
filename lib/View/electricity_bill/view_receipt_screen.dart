import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/View/dashdoard_view/bottom_navigation_bar_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';


class ViewReceiptScreen extends StatefulWidget {
  final String? bankName;
  const ViewReceiptScreen({super.key,this.bankName});

  @override
  State<ViewReceiptScreen> createState() => _ViewReceiptScreenState();
}


class _ViewReceiptScreenState extends State<ViewReceiptScreen> {

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
            // SizedBox(width: 10,),
          ],
        ),
      ),

      body: Container(
        color: lightGreyColor,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20,),
                SvgPicture.asset(AppImages.billImage,),
                SizedBox(height: 20,),
                text("Bill Pay Successful",
                    textColor:purpleGradientColor,fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w700),

                text("DESCO Postpaid",
                    textColor:greyColor,fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w400),
                SizedBox(height: 10,),
                Divider(thickness: .5,color: greyColor,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Transaction ID",
                        textColor:pinkColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                    text("#71L69PJK3",
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Amount",
                        textColor:pinkColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                    text("459.00 ₹",
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Charge",
                        textColor:pinkColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                    text("4.13 ₹",
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Total",
                        textColor:pinkColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                    text("463.13 ₹",
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text("Timestamp",
                        textColor:pinkColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                    text("01/11/22, 10:45PM",
                        textColor:greyColor,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w400),
                  ],
                ),

                SizedBox(height: 15,),
                Divider(height: 10,),

                const SizedBox(height: 50,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 55,
                  child: CommonButton(
                      text: "Back to home ",
                      textColor: white,
                      gradient: const LinearGradient(
                        colors: [pinkColor, purpleGradientColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontSize:18.0,
                      //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      //borderRadius: BorderRadius.circular(40.0),

                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => DashboardScreen(),));
                      }



                  ),
                ),

                const SizedBox(height: 20,),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 55,
                  child: CommonButton(
                      text: "VIEW RECEIPT",
                      textColor: white,
                      gradient: const LinearGradient(
                        colors: [pinkColor, purpleGradientColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                      fontSize:18.0,
                      //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      //borderRadius: BorderRadius.circular(40.0),

                      onPressed: (){

                      }



                  ),
                ),
              ],
            ),
          ),
        ),
      ),



    );
  }

}




