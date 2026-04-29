
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:flutter/gestures.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'health_child_insurance_screen.dart';
import 'health_insurance_from_screen.dart';



class HealthPlanInsuranceScreen extends StatefulWidget {
  const HealthPlanInsuranceScreen({super.key,});

  @override
  State<HealthPlanInsuranceScreen> createState() => _HealthPlanInsuranceScreenState();
}


class _HealthPlanInsuranceScreenState extends State<HealthPlanInsuranceScreen> {
  String? selectedAgeGroup;
  bool isChecked = false;
  int? selectIndex;

  List<Map<String, dynamic>> allData = [
    { "title": "₹1 Crore",},
    { "title": "₹2 Crore",},
    { "title": "₹20 Lakh",},
    { "title": "10 Lakh",},
    { "title": "₹50 Lakh",},
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(AppImages.iImage,color: white,),
                    text("Jigropay",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:white,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600),
                  ],
                ),
                text("Insurance Broking",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor:lightGreyColor,fontSize: 13,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w600),
              ],
            ),

            text("My Policies",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor:lightGreyColor,fontSize: 13,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w600),

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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: pinkColor.withOpacity(.4)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text("Covering",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400),

                            text("1 member",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text("Age Range",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400),
                            text("18-35 years",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 16,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600),
                          ],
                        ),
                        text("Change",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:pinkColor,fontSize: 18,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontWeight: FontWeight.w600),
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20,),

              _sectionTitle("Select cover amount"),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: allData.length,
                  itemBuilder: (context, index) {
                    bool isSelected = selectIndex == index;
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectIndex = index; // selected index update करो
                        });
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankAccountScreen(),));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                              gradient:isSelected? const LinearGradient(
                                colors: [pinkColor,purpleGradientColor], // light → dark purple
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ):null,
                            color: isSelected?null:lightGreyColor
                          ),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: text(allData[index]["title"],
                                    textColor:isSelected?white:blackColor,fontSize: 14,
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                    fontWeight: FontWeight.w500),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  },),
              ),

              const SizedBox(height: 25),
              _sectionTitle("Your insurer"),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: pinkColor.withOpacity(.4)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(AppImages.iciBnkImage,height: 20,),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                text("ICICI Lombard",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor:blackColor,fontSize: 13,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w600),

                                text("Nibhayye Vaade",
                                    textAlign: TextAlign.center,
                                    isCentered: true,
                                    textColor:greyColor,fontSize: 12,
                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                    fontWeight: FontWeight.w500),
                              ],
                            ),

                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            text("₹1,436",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600),
                            text("monthly",
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 13,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w400),


                          ],
                        ),

                      ],
                    ),
                    SizedBox(height: 10,),
                    text("Exclusive no room rent cap on any type",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:blackColor,fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400),
                    text("96.26% claim settlement rate",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:blackColor,fontSize: 13,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400),

                    SizedBox(height: 10,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: const LinearGradient(
                                colors: [pinkColor,purpleGradientColor], // light → dark purple
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                          ),
                          child: text("10,928 Hospitals",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor:white,fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w500),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: pinkColor)
                          ),
                          child: text("View Plan Details",
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor:purpleGradientColor,fontSize: 14,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  text(
                      "Premium (Incl. of GST)",
                      textColor: blackColor,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontSize: 15,fontWeight: FontWeight.w400
                  ),
                  text(
                    "₹2,899/month",
                    textColor: blackColor,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontSize: 14,fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
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
                    fontSize:18.0,
                    //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    //borderRadius: BorderRadius.circular(40.0),

                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HealthInsuranceFromScreen(),));
                    }



                ),
              ),

            ],
          ),
        ),
      ),



    );
  }
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: text(
          title,
          textColor:blackColor,fontSize: 20,
          fontFamily: FontFamily.plusJakartaSansBold,
          fontWeight: FontWeight.w600
      ),
    );
  }

  Widget _optionButton(String text1, IconData icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF6E2AE9) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? const Color(0xFF6E2AE9) : Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: text(
                  text1,
                  textColor:blackColor,fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w500
              ),
            ),
            Icon(icon, color: const Color(0xFF6E2AE9)),
          ],
        ),
      ),
    );
  }

  Widget _ageButton(String text1, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF1E7FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF6E2AE9) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: text(
            text1,
            textColor:blackColor,fontSize: 16,
            fontFamily: FontFamily.plusJakartaSansMedium,
            fontWeight: FontWeight.w500
        ),
      ),
    );
  }
}




