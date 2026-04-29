import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import '../../app_utils/custom_textFiled.dart';



class NpsDetailsScreen extends StatefulWidget {
  final String? npsServiceName;
  const NpsDetailsScreen({super.key,this.npsServiceName});

  @override
  State<NpsDetailsScreen> createState() => _NpsDetailsScreenState();
}


class _NpsDetailsScreenState extends State<NpsDetailsScreen> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  dynamic date;
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
            text(widget.npsServiceName??"",
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

              SizedBox(height: 10),
              text("Enter the details to retrieve your account",
                  textColor:blackColor,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),

              SizedBox(height: 15),
              text("PRAN (12 Digit)/Mobile Number ",
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
              const SizedBox(height: 10,),
              CustomRoundTextField(
                controller:mobileNumberController,

                keyboardType: TextInputType.phone,
                hintText: "Enter your PRAN (12 Digit)/Mobile Number ",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(12),],
              ),
              SizedBox(height: 15),
              text("DOB (dd/mm/yyyy)",
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
              const SizedBox(height: 10,),
              CustomRoundTextField(
                readOnly: true,
                onTap: (){
                  calenderForGetDay(context);
                },
                controller:dobController,
                hintText: "Enter your DOB (dd/mm/yyyy)",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10),],
              ),
                SizedBox(height: 15),
              text("Contribution Amount (Rs.)",
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
              const SizedBox(height: 10,),
              CustomRoundTextField(
                controller:amountController,
                keyboardType: TextInputType.phone,
                hintText: "Enter your Contribution Amount (Rs.)",
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
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
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
                              fontWeight: FontWeight.w500,fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium
                          )
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),

                    ],
                  ),
                ),
              ),

              SizedBox(height: 30,),
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
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
                  RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                                color: blackColor,
                                fontSize: 12,
                                fontFamily:
                                FontFamily.plusJakartaSansRegular)),
                        TextSpan(
                            text: 'terms and conditions',
                            recognizer:  TapGestureRecognizer()
                              ..onTap = () {

                              },
                            style: const TextStyle(
                                decoration: TextDecoration.underline,
                                color: blue1Color,
                                fontSize: 12,
                                fontFamily:
                                FontFamily.plusJakartaSansRegular)),
                      ])),
                ],
              ),
              const SizedBox(height: 15,),
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
        backgroundColor: white,
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
              child: Container(
                //height: 170,
                width: 300,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: red1Color
                        ),
                        child: text(
                            "nps national pension system",
                            textColor: white,
                            fontFamily: FontFamily.plusJakartaSansBold,
                            fontSize: 14
                        ),
                      ),
                      SizedBox(height: 10,),

                      text(
                          "National Pension System",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontSize: 14
                      ),
                      SizedBox(height: 10,),
                      Divider(thickness: .5,color: greyColor,),
                      text(
                          "PRAN (12 Digit)/Mobile Number (10 Digit) :9911223344",
                          textColor: blackColor,
                          fontFamily: FontFamily.plusJakartaSansMedium,
                          fontSize: 13
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
                  text: "Close",
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




