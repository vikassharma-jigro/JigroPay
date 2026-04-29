
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class EducationEnrollmentScreen extends StatefulWidget {
 final String? education;
  const EducationEnrollmentScreen({super.key,this.education});

  @override
  State<EducationEnrollmentScreen> createState() => _EducationEnrollmentScreenState();
}


class _EducationEnrollmentScreenState extends State<EducationEnrollmentScreen> {
  TextEditingController enrollmentNumberController = TextEditingController();

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
            text(widget.education??"",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor:white,fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600),

            SvgPicture.asset(AppImages.educationImage,height: 20,),

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
              text("Enter your Enrollment Number to retrieve your account details.",
                  textColor:greyColor,fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w600),

              SizedBox(height: 10),
              TextField(
                controller: enrollmentNumberController,
                // onChanged: (value) => filterSearch(value),
                // onSubmitted: (v) => filterSearch(v),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightorangeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: lightorangeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: lightorangeColor),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Other decoration properties...


                  filled: true,

                  fillColor: white,
                  hintText: "Enrollment Number",
                  hintStyle: const TextStyle(fontSize: 16.0, color: lightWhiteColor, fontFamily: 'Roboto-Light'),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
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

                    }



                ),
              ),
              SizedBox(height: 20,),
              text("We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:greyColor,fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400),

            ],
          ),
        ),
      ),



    );
  }

}




