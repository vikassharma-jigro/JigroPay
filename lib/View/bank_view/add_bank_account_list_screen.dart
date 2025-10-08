import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'add_bank_account_screen.dart';


class AddBankAccountListScreen extends StatefulWidget {
  const AddBankAccountListScreen({super.key});

  @override
  State<AddBankAccountListScreen> createState() => _AddBankAccountListScreenState();
}


class _AddBankAccountListScreenState extends State<AddBankAccountListScreen> {
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allData = [
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "SBI",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "PNB",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "UCO",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "BOI",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "BOB",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "RBI",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "Kotak",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "India",},
    {"image": SvgPicture.asset(AppImages.rajImage,height: 50,), "bankName": "Rajasthan",},
  ];

  List<Map<String, dynamic>> allBankData = [
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "The Rayat Sevak Co-Op Bank",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "PNB",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "UCO",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "BOI",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "BOB",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "RBI",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "Kotak",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "India",},
    {"image": SvgPicture.asset(AppImages.bankImage,height: 50,), "bankName": "Rajasthan",},
  ];

  // 🔹 Filtered list
  List<Map<String, dynamic>> filteredData = [];
  @override
  void initState() {
    super.initState();
    filteredData = allData;
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = allData;
      } else {
        filteredData = allData
            .where((item) =>
        item['bankName'].toLowerCase().contains(query.toLowerCase()) )
            .toList();
      }
    });
  }

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
            // SizedBox(width: 10,),
            Expanded(
              child: text("Add Your Bank Account\n for UPI Payments ",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:white,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),
            ),
            Icon(Icons.more_vert,color: white,)
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
                onChanged:
                filterSearch,
                // });

                onSubmitted: (v) {

                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: greyColor,),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Other decoration properties...


                  filled: true,

                  // search Icon ------------------
                  prefixIcon: GestureDetector(
                    onTap: () {
                      filterSearch(searchController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 10, bottom: 5, top: 5),
                      child: const Icon(Icons.search, color: greyColor),
                    ),
                  ),
                  fillColor: white,
                  hintText: "Search by name",
                  hintStyle: const TextStyle(fontSize: 16.0, color: greyColor, fontFamily: 'Roboto-Light'),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
              SizedBox(height: 20,),
              text("POPULAR BANKS",
                  textColor:blackColor,fontSize: 15,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w700),
              SizedBox(height: 20,),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1.3,
                ),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankAccountScreen(),));
                    },
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        item['image'],

                        Expanded(
                          child: text(item['bankName'],
                              textColor:blackColor,fontSize: 14,
                              textAlign: TextAlign.center,
                              isCentered: true,
                              fontFamily: FontFamily.plusJakartaSansRegular,
                              fontWeight: FontWeight.w400),
                        ),

                      ],
                    ),
                  );
                },),

              SizedBox(height: 20,),
              text("ALL BANKS",
                  textColor:blackColor,fontSize: 15,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w700),

              SizedBox(height: 20,),
              ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: allBankData.length,
                itemBuilder: (context, index) {
                  final item = allBankData[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        item['image'],

                        SizedBox(width: 20,),
                        text(item['bankName'],
                            textColor:blackColor,fontSize: 15,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w500),

                        SizedBox(height: 15,),
                        Divider(thickness: .5,height: 5,color: greyColor,)
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

}

