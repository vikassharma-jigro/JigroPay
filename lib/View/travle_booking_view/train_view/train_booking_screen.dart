import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:jigrotech/View/travle_booking_view/train_view/search_train_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/custom_textFiled.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class TrainBookingScreen extends StatefulWidget {
  final String? ncmcServiceName;
  const TrainBookingScreen({super.key,this.ncmcServiceName});

  @override
  State<TrainBookingScreen> createState() => _TrainBookingScreenState();
}


class _TrainBookingScreenState extends State<TrainBookingScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController dateController = TextEditingController();
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
            text("Book Train Tickets",
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

              SizedBox(height: 15),
              text("From",
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
              const SizedBox(height: 10,),
              CustomRoundTextField(
                controller:fromController,

                keyboardType: TextInputType.phone,
                hintText: "From",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10),],
              ),
              SizedBox(height: 15),
              text("To",
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
              const SizedBox(height: 10,),
              CustomRoundTextField(
                controller:toController,
                keyboardType: TextInputType.phone,
                hintText: "To",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10),],
              ),

                SizedBox(height: 15),
              text("Journey Date",
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  textColor:blackColor,fontSize: 14,fontWeight: FontWeight.w400),
              const SizedBox(height: 10,),
              CustomRoundTextField(
                readOnly: true,
                onTap: (){
                  calenderForGetDay(context);
                },
                controller:dateController,
                keyboardType: TextInputType.phone,
                hintText: "Journey Date",
                maxLines: 2,
                fillColor: Colors.transparent,
                //padding: const EdgeInsets.symmetric(vertical: 2),
                inputFormatters: [LengthLimitingTextInputFormatter(10),],
              ),

              const SizedBox(height: 50,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                    text: "SEARCH TRAINS",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SearchTrainScreen(),));
                    }
                ),
              ),
              SizedBox(height: 10,),
              Center(
                child: text("IRCTC Authorized Partner",
                    textColor: blue1Color,
                    fontWeight: FontWeight.w600,fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansBold
                ),
              ),
              SizedBox(height: 10,),
              Image.asset(AppImages.trainImage),

              SizedBox(height: 15,),
              text("OTHER SERVICES",
                  textColor: blackColor,
                  fontWeight: FontWeight.w400,fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansRegular
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(AppImages.foodImage,height: 40,),
                      SizedBox(height: 10,),
                      text("Order Food On train",
                          textColor: blackColor,
                          fontWeight: FontWeight.w400,fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Image.asset(AppImages.runningStatusImage,height: 40,),
                      SizedBox(height: 10,),
                      text("Running Status",
                          textColor: blackColor,
                          fontWeight: FontWeight.w400,fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(AppImages.pnrImage,height: 40,),
                      SizedBox(height: 10,),
                      text("PNR Status",
                          textColor: blackColor,
                          fontWeight: FontWeight.w400,fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(AppImages.calendarImage,height: 40,),
                      SizedBox(height: 10,),
                      text("Train Schedule",
                          textColor: blackColor,
                          fontWeight: FontWeight.w400,fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20,),
              text("IRCTC SERVICES",
                  textColor: blackColor,
                  fontWeight: FontWeight.w400,fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansRegular
              ),

              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(AppImages.faceIdImage,height: 40,),
                      SizedBox(width: 10,),
                      text("Create IRCTC UserID",
                          textColor: blackColor,
                          fontWeight: FontWeight.w400,fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Image.asset(AppImages.resetPasswordImage,height: 40,),
                      SizedBox(width: 10,),
                      text("Reset IRCTC Password",
                          textColor: blackColor,
                          fontWeight: FontWeight.w400,fontSize: 12,
                          fontFamily: FontFamily.plusJakartaSansRegular
                      ),
                    ],
                  ),

                ],
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
        dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      }
    });
  }
}




