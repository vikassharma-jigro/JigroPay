
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:jigrotech/View/insurance_view/traveller_list_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';



class TravellerDetails extends StatefulWidget {

  const TravellerDetails({super.key,});

  @override
  State<TravellerDetails> createState() => _TravellerDetailsState();
}


class _TravellerDetailsState extends State<TravellerDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  dynamic date;
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

          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text("Note:",
                          textColor: orangeColor,
                          fontWeight: FontWeight.w600,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansBold
                      ),
                      text("Adding your passport number is recommended for countries requiring insurance for visa approval.",
                          textColor: greyColor,
                          fontWeight: FontWeight.w400,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              text("Traveller Details",
                  maxLine: 2,
                  textColor:blackColor,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
              SizedBox(height: 10,),
              CustomRoundTextField(
                controller:nameController,
                keyboardType: TextInputType.name,
                hintText: "Full Name",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(20),],
              ),
              text("As mentioned on traveller's passport",
                  maxLine: 2,
                  textColor:blackColor,fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400),
              SizedBox(height: 20,),
              CustomRoundTextField(
                readOnly: true,
                onTap: (){
                  calenderForGetDay(context);
                },
                controller:dobController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Dob",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(20),],
              ),
              text("Traveller's age will determine final premium",
                  maxLine: 2,
                  textColor:blackColor,fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400),

              SizedBox(height: 20,),
              CustomRoundTextField(
                controller:passportController,
                keyboardType: TextInputType.emailAddress,
                hintText: "Passport Number (Optional)",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(20),],
              ),

              SizedBox(height: 120,),

              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                    text: "ADD",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TravellerListScreen(),));
                    }



                ),
              ),

            ],
          ),
        ),
      ),



    );
  }
  calenderForGetDay(BuildContext context) async {
    return await showDatePicker(
        fieldHintText: "dd-MM-yyyy",
        keyboardType: TextInputType.name,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
              primarySwatch: Colors.grey,
              splashColor: Colors.blue,
              hintColor: Colors.blue,
              colorScheme: const ColorScheme.light(
                  primary: purpleGradientColor,
                  onSecondary: Colors.blue,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                  secondary: Colors.white),
              dialogBackgroundColor: Colors.white,
            ),
            child: child ?? const Text(''),
          );
        },
        initialDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day),
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month, DateTime.now().day))
        .then((selectedDate) {
      if (selectedDate != null) {
        date = DateFormat('yyyy-MM-dd').format(selectedDate);
        print("date>>>>${date}");
        dobController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      }
    });
  }
}




