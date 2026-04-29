import 'package:flutter/material.dart';
import 'package:jigrotech/View/insurance_view/travel_calender_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class TravelInsuranceCountriesScreen extends StatefulWidget {

  const TravelInsuranceCountriesScreen({super.key,});

  @override
  State<TravelInsuranceCountriesScreen> createState() => _TravelInsuranceCountriesScreenState();
}


class _TravelInsuranceCountriesScreenState extends State<TravelInsuranceCountriesScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> options = [
    "Thailand",
    "United Arab Emirates",
    "Vietnam",
    "Indonesia",
    "Canada",
    "United States of America",
    "Sri Lanka",
  ];
  List<bool> isCheckedList = [];
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
    filteredOptions = options;
    isCheckedList = List.generate(filteredOptions.length, (_) => false);// initially show all
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
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios,color: white,),
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
              text("Where are you travelling?",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:blackColor,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),

              text("Choose one or more countries",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:blackColor,fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w400),
              SizedBox(height: 15,),
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
                  hintText: "Search by Countries",
                  hintStyle: const TextStyle(fontSize: 16.0, color: blackColor, fontFamily: FontFamily.plusJakartaSansRegular),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
              SizedBox(height: 15),
              text("Popular Countries",
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
                    child:  Container(
                      padding: EdgeInsets.symmetric(horizontal: 7,vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color:greyColor)
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: text(filteredOptions[index],
                                    maxLine: 2,
                                    textColor:blackColor,fontSize: 13,
                                    fontFamily: FontFamily.plusJakartaSansMedium,
                                    fontWeight: FontWeight.w500),
                              ),
                              Checkbox(
                                value: isCheckedList[index],
                                onChanged: (value) {
                                  setState(() {
                                    isCheckedList[index] = value!;
                                  });
                                },
                                activeColor: Colors.blue, // customize color if you want
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  );

                },),
              const SizedBox(height: 50,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                    text: "Next",
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTravelDatesScreen(),));

                    }
                ),
              ),

            ],
          ),
        ),
      ),



    );
  }

}




