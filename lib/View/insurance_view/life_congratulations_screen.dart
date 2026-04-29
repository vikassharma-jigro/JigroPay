
import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'life_quotations_screen.dart';




class LifeCongratulationsScreen extends StatefulWidget {

  const LifeCongratulationsScreen({super.key,});

  @override
  State<LifeCongratulationsScreen> createState() => _LifeCongratulationsScreenState();
}


class _LifeCongratulationsScreenState extends State<LifeCongratulationsScreen> {
  bool? isSelectedGender;
  bool? isSelected;
  double _currentSliderRangeValue = 50000;
  RangeValues priceRangeValues = const RangeValues(50000, 10000000);
  String? selectedOccupation; // stores selected value

  final List<String> occupations = [
    "Student",
    "Employee",
    "Business",
    "Other",
  ];
  String? selectedEducation;

  final List<String> education = [
    "Engineer",
    "Doctor",
    "Teacher",
    "Businessman",
    "Artist",
    "Other",
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
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
            ),
            Expanded(
              child: Center(
                child: text("Term Life Insurance",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor:white,fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w600),
              ),
            ),

            // SizedBox(width: 10,),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 130,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [pinkColor, purpleGradientColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.call,color: white,),
                  text( "Talk To Us",
                    textColor: white,

                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontSize:18.0,),
                ],
              )
            ),
            SizedBox(height: 20,),
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
                  fontSize:18.0,
                  //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  //borderRadius: BorderRadius.circular(40.0),

                  onPressed: (){
                    show(context);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => AccidentFormScreen(),));
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text("Congratulations! Your recommended cover is here",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:blackColor,fontSize: 24,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),

              SizedBox(height: 15,),
              Center(child: Image.asset(AppImages.congraImage,height: 100,)),

              SizedBox(height: 20,),
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          text("Select Sum Assured",
                              textColor:blackColor,fontSize: 18,
                              fontFamily: FontFamily.plusJakartaSansBold,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                      SizedBox(height: 10,),
                      text(
                        "₹${_currentSliderRangeValue.round()}",
                        textColor: blue1Color,
                        fontWeight: FontWeight.w600,fontSize: 18,fontFamily: FontFamily.plusJakartaSansBold,
                        isCentered: true,textAlign: TextAlign.center
                         ),
                      Slider(
                        thumbColor: blueColor,
                        activeColor: Colors.red,
                        inactiveColor: blue1Color,
                        value: _currentSliderRangeValue,
                        max: 10000000,
                        divisions: 50000,
                        label: _currentSliderRangeValue.round().toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderRangeValue = value;
                          });
                        },

                      ),

                      Container(
                        margin: const EdgeInsets.only(left: 15, right: 15, top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(
                              "₹${priceRangeValues.start.round()}",
                              textColor: greyColor,
                              fontWeight: FontWeight.w400,fontSize: 13,fontFamily: FontFamily.plusJakartaSansRegular,

                            ),
                            text(
                              "₹${priceRangeValues.end.round()}",
                              textColor: greyColor,
                              fontWeight: FontWeight.w400,fontSize: 13,fontFamily: FontFamily.plusJakartaSansRegular,

                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightBlueColor.withOpacity(.6)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: text(
                                  "Ideal recommended cover is ₹1 Crore, which is 10x of income.",
                                  textColor: blueColor,
                                  isCentered: true,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w400,fontSize: 13,fontFamily: FontFamily.plusJakartaSansRegular,

                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightBlueColor.withOpacity(.6)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: text(
                                  "Recommended cover till age 60 years",
                                  textColor: blackColor,
                                  isCentered: true,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w400,fontSize: 13,fontFamily: FontFamily.plusJakartaSansRegular,

                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),






            ],
          ),
        ),
      ),



    );
  }


   void show(BuildContext context){
    showDialog(context: context, builder: (_)=>StatefulBuilder(builder:(context, setStateDialog ){
      Widget buildOccupationButton(String occupation) {
        bool isSelected = selectedOccupation == occupation;

        return GestureDetector(
          onTap: () {
            setStateDialog(() {
              selectedOccupation = occupation;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? lightorangeColor : white,
              border: Border.all(color: pinkColor),
            ),
            child: text(
              occupation,
              textAlign: TextAlign.center,
              isCentered: true,
              textColor: blackColor,
              fontSize: 16,
              fontFamily: FontFamily.plusJakartaSansRegular,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }

      Widget buildEducationButton(String title) {
        final bool isSelected = selectedEducation == title;

        return GestureDetector(
          onTap: () {
            setStateDialog(() {
              selectedEducation = title;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? lightorangeColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: pinkColor),
            ),
            alignment: Alignment.center,
            child: text(
              title,
                textAlign: TextAlign.center,
                isCentered: true,
                textColor:blackColor,fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400
            ),
          ),
        );
      }
      return AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                //height: 170,
                width: 300,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: text("You are just one step away",
                            textColor: blackColor,fontSize: 18,
                            isCentered: true,
                            fontWeight: FontWeight.w600,fontFamily: FontFamily.plusJakartaSansBold
                        ),
                      ),
                      text(" Provide details to calculate the exact price.",
                          textColor: greyColor,fontSize: 13,
                          isCentered: true,
                          fontWeight: FontWeight.w400,fontFamily: FontFamily.plusJakartaSansRegular
                      ),

                      SizedBox(height: 10,),
                      text(
                          "Gender",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 14
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setStateDialog(() {
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
                                setStateDialog(() {
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
                      SizedBox(height: 10,),
                      text(
                          "Occupation",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 14
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 2,
                              child: buildOccupationButton("Student",)),
                          const SizedBox(width: 10),
                          Expanded(
                              flex: 2,
                              child: buildOccupationButton("Employee")),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 🔹 Second Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 2,
                              child: buildOccupationButton("Business")),
                          const SizedBox(width: 10),
                          Expanded(
                              flex: 2,
                              child: buildOccupationButton("Other")),
                        ],
                      ),
                      SizedBox(height: 10,),


                      SizedBox(height: 10,),
                      text(
                          "Education",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 14
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(child: buildEducationButton("Graduate")),
                          const SizedBox(width: 10),
                          Expanded(child: buildEducationButton("Post Graduate")),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 🔹 Third Row
                      Row(
                        children: [
                          Expanded(child: buildEducationButton("Diploma")),
                          const SizedBox(width: 10),
                          Expanded(child: buildEducationButton("Other")),
                        ],
                      ),
                      SizedBox(height: 10,),
                      text(
                          "Have you consumed tobacco in the last 30 days?",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansBold,
                          fontSize: 14
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: (){
                                setStateDialog(() {
                                  isSelected = true;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isSelected==true?lightorangeColor:white,
                                    border: Border.all(color: pinkColor)
                                ),
                                child: text("Yes",
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
                                setStateDialog(() {
                                  isSelected = false;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:  isSelected == true?white:lightorangeColor,
                                    border: Border.all(color: pinkColor)
                                ),
                                child: text("No",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LifeQuotationsScreen(),));
                  }



              ),
            ),
          ],
        ),
      );
    }));
   }







}




