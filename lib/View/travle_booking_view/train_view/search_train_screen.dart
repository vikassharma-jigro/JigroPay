import 'package:flutter/material.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/flight_travle_form_screen.dart';
import 'package:jigrotech/View/travle_booking_view/train_view/train_booking_pay_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class SearchTrainScreen extends StatefulWidget{
  const SearchTrainScreen({super.key});
  @override

  State<SearchTrainScreen> createState() => _SearchTrainScreenState();
}

class _SearchTrainScreenState extends State<SearchTrainScreen>{
  bool isChecked = false;
  int? isSelected;
  @override
  void initState() {

    super.initState();
  }

  List<Map<String, dynamic>> allDate = [
    {"name": "Sun", "date": "12", "amount": "₹6,645"},
    {"name": "Mon", "date": "13", "amount": "₹3,335"},
    {"name": "Tue", "date": "14", "amount": "₹3,645"},
    {"name": "Wed", "date": "15", "amount": "₹3,645"},
    {"name": "Thu", "date": "16", "amount": "₹3,645"},
    {"name": "Fri", "date": "17", "amount": "₹3,645"},
    {"name": "Sat", "date": "18", "amount": "₹3,645"},
  ];

  List<Map<String, dynamic>> trainData = [
    {"name": "12963 - Udaipur Express", "timeTo": "22:35", "amount": "₹6,645","timeFrom": "23:35"},
    {"name": "12991 - Kavi Guru Exp", "timeTo": "18:40", "amount": "₹3,335","timeFrom":"20:33"},
    {"name": "22461 - JP UDZ Exp", "timeTo": "08:25", "amount": "₹3,645","timeFrom":"10:33"},
    {"name": "12963 - Udaipur Express", "timeTo": "22:00", "amount": "₹3,645","timeFrom":"23:33"},
    {"name": "22461 - JP UDZ Exp", "timeTo": "24:00", "amount": "₹3,645","timeFrom":"25:33"},
    {"name": "12991 - Kavi Guru Exp", "timeTo": "08:25", "amount": "₹3,645","timeFrom":"10:33"},
  ];

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
              children: [
                Row(
                  children: [
                    text("JAI",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:white,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600),
                    Icon(Icons.arrow_forward,color: white,),
                    text("DEL",
                        textAlign: TextAlign.center,
                        isCentered: true,
                        textColor:white,fontSize: 18,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w600),
                  ],
                ),
                text("13 Oct • 1 Traveller • Economy",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor:white,fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontWeight: FontWeight.w400),
              ],
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: white)
              ),
              child: text("About",
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
            children: [
              SizedBox(
                height: 60,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allDate.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelectedColor = isSelected==index;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            isSelected = index;
                          });
                        },
                        child: Container(
                          color: isSelectedColor?lightBlueColor:Colors.transparent,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  text(allDate[index]["name"],
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:isSelectedColor?blue1Color:greyColor,fontSize: 14,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),

                                  text(allDate[index]["date"],
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:isSelectedColor?blue1Color:greyColor,fontSize: 14,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                              text(allDate[index]["amount"],
                                  textAlign: TextAlign.center,
                                  isCentered: true,
                                  textColor:isSelectedColor?blue1Color:blackColor,fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                  fontWeight: FontWeight.w400),
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: trainData.length,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrainBookingPayScreen(),));
                      },
                      child: Card(
                        color: white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text(trainData[index]["name"],
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 14,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w400),
                                  text(trainData[index]["amount"],
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                              SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text(trainData[index]["timeTo"],
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600),
                                  Column(
                                    children: [
                                      text("9h 50m Non stop",
                                          textAlign: TextAlign.center,
                                          isCentered: true,
                                          textColor:blackColor,fontSize: 14,
                                          fontFamily: FontFamily.plusJakartaSansRegular,
                                          fontWeight: FontWeight.w400),
                                      SizedBox(height: 5,),
                                      Container(
                                        height: 2,width: 150,
                                        color: lightGreyColor,
                                      )
                                    ],
                                  ),
                                  text(trainData[index]["timeFrom"],
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),

                              SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text("JAI",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),

                                  text("DEL",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),

                              SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  text("Extra Off: ₹209",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:red1Color,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),

                                  text("Lock Price @ ₹209",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:red1Color,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),


                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },),
            ],
          ),
        ),
      ),
    );
  }
}