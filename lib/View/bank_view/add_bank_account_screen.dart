import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'check_balance_screen.dart';


class AddBankAccountScreen extends StatefulWidget {
  const AddBankAccountScreen({super.key});

  @override
  State<AddBankAccountScreen> createState() => _AddBankAccountScreenState();
}


class _AddBankAccountScreenState extends State<AddBankAccountScreen> {
TextEditingController accountNumberController = TextEditingController();
TextEditingController ifcCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 55,
          child: CommonButton(
            text: "Next",
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
            onPressed: (){
              //Navigator.push(context, MaterialPageRoute(builder: (context) => CheckBalanceScreen(),));

            },),
        ),
      ),
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
            Expanded(
              child: text("Add Bank Account",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:white,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
            ),
            Icon(Icons.more_vert,color: white,)
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightGreyColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10, // shadow spread
                      offset: const Offset(0, 4), // x, y direction of shadow
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.rajImage,height: 50,),
                              SizedBox(width: 23,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  text("Selected bank",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:greyColor,fontSize: 14,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),

                                  text("Rajasthan Gramin Bank-8093",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansMedium,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ],
                          ),

                          Icon(Icons.edit,color: pinkColor,),
                        ],
                      ),

                    ]
                ),
              ),

              SizedBox(height: 20,),
              TextField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                onChanged:(i){

                },

                onSubmitted: (v) {

                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  filled: true,
                  fillColor: white,
                  hintText: "Account Number",
                  hintStyle: const TextStyle(fontSize: 16.0, color: greyColor, fontFamily: 'Roboto-Light'),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),

              SizedBox(height: 20,),
              TextField(
                controller: ifcCodeController,
                keyboardType: TextInputType.number,
                onChanged:(i){

                },

                onSubmitted: (v) {

                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  filled: true,
                  fillColor: white,
                  hintText: "IFC Code",
                  hintStyle: const TextStyle(fontSize: 16.0, color: greyColor, fontFamily: 'Roboto-Light'),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
            ],
          ),
        ),
      ),



    );
  }

}

