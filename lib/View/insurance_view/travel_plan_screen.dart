import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_contact_details_screen.dart';
import 'package:jigrotech/View/travle_booking_view/flight_view/flight_travle_form_screen.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class TravelPlanScreen extends StatefulWidget{
  const TravelPlanScreen({super.key});
  @override

  State<TravelPlanScreen> createState() => _TravelPlanScreenState();
}

class _TravelPlanScreenState extends State<TravelPlanScreen>{
  int? selectedIndex;
  @override
  void initState() {

    super.initState();
  }
  String? selectedSumInsured;

  final List<String> insuredOptions = [
    "₹1 Lakh",
    "₹5 Lakh",
    "₹10 Lakh",
    "₹25 Lakh",
    "₹50 Lakh",
    "₹1 Crore",
  ];
  List<Map<String, dynamic>> travellingList = [
    {"name": "digit", "dis": "Travel Guard","amount": "₹468","point1":"Trip cancellation","point2":"Baggage loss","point3":"Loss of passport","point4":"Personal accident",},
    {"name": "TATA AIG", "dis": "Travel Protector","amount": "₹512","point1":"Trip cancellation","point2":"Baggage loss","point3":"Loss of passport","point4":"Personal accident",},
    {"name": "Reliance General", "dis": "Travel Care","amount": "₹445","point1":"Trip cancellation","point2":"Baggage loss","point3":"Loss of passport","point4":"Personal accident",},
    {"name": "Niva Bupa", "dis": "Travel Shield","amount": "₹589","point1":"Trip cancellation","point2":"Baggage loss","point3":"Loss of passport","point4":"Personal accident",},
     ];

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
            Expanded(
              child: text("Select Plan",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              text("Sum Insured Per Traveller",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:blackColor,fontSize: 14,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w500),
              SizedBox(height: 10,),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedSumInsured,
                    hint: Text(
                      "Select Sum Insured",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.deepPurple),
                    items: insuredOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSumInsured = value;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Info Box (optional)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Note: This coverage amount will apply individually to each traveller in your plan.",
                  style: TextStyle(
                    color: Colors.deepPurple[700],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.star,color: yellowColor,),
                      text("Compare benefits across plans",
                          textAlign: TextAlign.center,
                          isCentered: true,
                          textColor:blackColor,fontSize: 14,
                          fontFamily: FontFamily.plusJakartaSansRegular,
                          fontWeight: FontWeight.w500),
                      SizedBox(width: 20,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: purpleGradientColor
                        ),
                        child: text("Compare",textColor: white,
                            fontFamily: FontFamily.plusJakartaSansBold,
                        fontSize: 15,fontWeight: FontWeight.w500
                        ),

                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: travellingList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(travellingList[index]["name"],
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600),

                            text(travellingList[index]["amount"],
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansBold,
                                fontWeight: FontWeight.w600),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(travellingList[index]["dis"],
                                textAlign: TextAlign.center,
                                isCentered: true,
                                textColor:blackColor,fontSize: 14,
                                fontFamily: FontFamily.plusJakartaSansRegular,
                                fontWeight: FontWeight.w500),
                            Radio<int>(

                              value: index,
                              groupValue: selectedIndex,
                              activeColor: Colors.deepPurple,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedIndex = value;
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TravelContactDetailsScreen(),));
                              },
                            ),
                          ],
                        ),
                        text(travellingList[index]["point1"],
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500),
                        text(travellingList[index]["point2"],
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500),
                        text(travellingList[index]["point3"],
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500),
                        text(travellingList[index]["point4"],
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blackColor,fontSize: 14,
                            fontFamily: FontFamily.plusJakartaSansRegular,
                            fontWeight: FontWeight.w500),
                      ],
                    ),
                  );
                },)
            ],
          ),
        ),
      ),
    );
  }
  Widget _quantityButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 20,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}