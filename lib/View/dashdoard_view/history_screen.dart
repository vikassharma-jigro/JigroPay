
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class HistoryScreen extends StatefulWidget {

  const HistoryScreen({super.key,});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}


class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> options = [
    "SHARMA STORE",
    "JOHN KUMAR",
    "GROCERY MART",
    "RESTAURANT ABC",
    "PRIYA SHARMA",

  ];
  List<String> filteredOptions = [];
  void _filterList(String query) {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredOptions = options
          .where((item) => item.toLowerCase().contains(query))
          .toList();
    });
  }
  @override
  void initState() {
    filteredOptions = options; // initially show all
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Expanded(
              child: text("History",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:white,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
            ),
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
              TextField(
                controller: searchController,
                onChanged:(i){
                  _filterList(i);
                },
                // filterSearch,
                // });

                onSubmitted: (v) {
                  _filterList(v);
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: purpleGradientColor),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: purpleGradientColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: purpleGradientColor),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // Other decoration properties...


                  filled: true,

                  // search Icon ------------------
                  prefixIcon: GestureDetector(
                    onTap: () {
                      // filterSearch(searchController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 0, bottom: 5, top: 5),
                      child: const Icon(Icons.search, color: greyColor),
                    ),
                  ),
                  fillColor: white,
                  hintText: "Search by provider",
                  hintStyle: const TextStyle(fontSize: 16.0, color: blackColor, fontFamily: FontFamily.plusJakartaSansRegular),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
              SizedBox(height: 15),
              text("All History",
                  textColor:blackColor,fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
              SizedBox(height: 15),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: filteredOptions.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:  GestureDetector(
                      onTap: (){
                           },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color:greyColor)
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.history),
                                    SizedBox(width: 20,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        text(filteredOptions[index],
                                            maxLine: 2,
                                            textColor:blackColor,fontSize: 13,
                                            fontFamily: FontFamily.plusJakartaSansMedium,
                                            fontWeight: FontWeight.w500),

                                        text("Today, 2:45 PM",
                                            maxLine: 2,
                                            textColor:greyColor,fontSize: 13,
                                            fontFamily: FontFamily.plusJakartaSansRegular,
                                            fontWeight: FontWeight.w400),
                                        text("Debited from",
                                            maxLine: 2,
                                            textColor:greyColor,fontSize: 13,
                                            fontFamily: FontFamily.plusJakartaSansRegular,
                                            fontWeight: FontWeight.w400),
                                      ],
                                    ),
                                  ],
                                ),
                                text("₹27",
                                    maxLine: 2,
                                    textColor:blackColor,fontSize: 18,
                                    fontFamily: FontFamily.plusJakartaSansBold,
                                    fontWeight: FontWeight.w500),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  );

                },)
            ],
          ),
        ),
      ),



    );
  }

}




