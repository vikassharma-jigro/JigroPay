import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'add_bank_account_list_screen.dart';


class SelfAccountScreen extends StatefulWidget {
  const SelfAccountScreen({super.key});

  @override
  State<SelfAccountScreen> createState() => _SelfAccountScreenState();
}


class _SelfAccountScreenState extends State<SelfAccountScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];
  List<Map<String, dynamic>> allData = [
    {"name": "Vikash Sharma", "phone": "9949494949", "amount": "₹286 Received on 05 Jan"},
    {"name": "Rohit Verma", "phone": "9876543210", "amount": "₹150 Received on 10 Jan"},
    {"name": "Aman Gupta", "phone": "8899776655", "amount": "₹320 Received on 12 Jan"},
    {"name": "Vikas Singh", "phone": "7778889999", "amount": "₹500 Received on 15 Jan"},
  ];

  // 🔹 Filtered list
  List<Map<String, dynamic>> filteredData = [];

  Future<void> getContacts() async {
    // Permission maango
    if (await FlutterContacts.requestPermission()) {
      // Contacts fetch karo (with phones)
      List<Contact> fetchedContacts =
      await FlutterContacts.getContacts(withProperties: true);

      setState(() {
        contacts = fetchedContacts;
      });
    } else {
      debugPrint("Permission denied");
    }
  }
  @override
  void initState() {
    super.initState();
    getContacts();
    filteredData = allData;
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredData = allData;
      } else {
        filteredData = allData
            .where((item) =>
        item['name'].toLowerCase().contains(query.toLowerCase()) ||
            item['phone'].toLowerCase().contains(query.toLowerCase()))
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
              child: text("Send Money to Any Bank A/c",
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: lightGreyColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10, // shadow spread
                      offset: const Offset(0, 4), // x, y direction of shadow
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.bankImage,height: 50,),
                              SizedBox(width: 23,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text("Enter Bank A/c no & IFSC",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600),

                                  text("Send money to any Bank instantly",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:greyColor,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios,color: greyColor,),
                        ],
                      ),
                    ]
                ),
              ),

              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightGreyColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10, // shadow spread
                      offset: const Offset(0, 4), // x, y direction of shadow
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.upiAcImage,height: 50,),
                              SizedBox(width: 23,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  text("Enter UPI ID/Mobile Number",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600),

                                  text("Send money to Gpay, Phonepe, Bhim or\nany UPI app",
                                      textAlign: TextAlign.start,
                                      isCentered: false,
                                      textColor:greyColor,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios,color: greyColor,),
                        ],
                      ),
                    ]
                ),
              ),

              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightGreyColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10, // shadow spread
                      offset: const Offset(0, 4), // x, y direction of shadow
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.selfAImage,height: 50,),
                              SizedBox(width: 23,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  text("Self Transfer",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600),

                                  text("Select A/c where you want to\nsend money",
                                      textAlign: TextAlign.start,
                                      isCentered: false,
                                      textColor:greyColor,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios,color: greyColor,),
                        ],
                      ),
                    ]
                ),
              ),

              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: lightGreyColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10, // shadow spread
                      offset: const Offset(0, 4), // x, y direction of shadow
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(AppImages.rajImage,height: 50,),
                              SizedBox(width: 23,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  text("Rajasthan Gramin Bank-8093",
                                      textAlign: TextAlign.center,
                                      isCentered: true,
                                      textColor:blackColor,fontSize: 16,
                                      fontFamily: FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w600),

                                  text("Check Balance",
                                      textAlign: TextAlign.start,
                                      isCentered: false,
                                      textColor:blue1Color,fontSize: 13,
                                      fontFamily: FontFamily.plusJakartaSansRegular,
                                      fontWeight: FontWeight.w400),
                                ],
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios,color: greyColor,),
                        ],
                      ),
                    ]
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddBankAccountListScreen(),));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(AppImages.addIcon,height: 50,),
                        SizedBox(width: 20,),
                        text("Add another Bank A/c",
                            textAlign: TextAlign.center,
                            isCentered: true,
                            textColor:blue1Color,fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w600),
                      ],
                    ),

                    Icon(Icons.arrow_forward_ios,color: greyColor,),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Divider(thickness: .5,color: greyColor,height: 10,),
              SizedBox(height: 30,),
              text("Recents & Saved Beneficiaries",
                  textColor:blackColor,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w700),

              SizedBox(height: 30,),
              TextField(
                controller: searchController,
                onChanged:
                  filterSearch,
                  // });

                onSubmitted: (v) {

                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  // Other decoration properties...


                  filled: true,

                  // search Icon ------------------
                  suffixIcon: GestureDetector(
                    onTap: () {
                      filterSearch(searchController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 0, bottom: 5, top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: blue1Color,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(Icons.search, color: white),
                      ),
                    ),
                  ),
                  fillColor: lightGreyColor,
                  hintText: "Search by name",
                  hintStyle: const TextStyle(fontSize: 16.0, color: blackColor, fontFamily: 'Roboto-Light'),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),

              SizedBox(height: 20,),
              ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(item['name'],
                        textColor:blackColor,fontSize: 15,
                        fontFamily: FontFamily.plusJakartaSansBold,
                        fontWeight: FontWeight.w700),
                    ListView.builder(
                      itemCount: contacts.length,
                      shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          leading: (contact.photo != null)
                              ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
                              : const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(contact.displayName),
                          subtitle: Text(contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : 'No number'),
                        );
                      },
                    ),

                    // text(item['phone'],
                    //     textColor:blackColor,fontSize: 14,
                    //     fontFamily: FontFamily.plusJakartaSansRegular,
                    //     fontWeight: FontWeight.w400),
                    text(item['amount'],
                        textColor:blue1Color,fontSize: 14,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                        fontWeight: FontWeight.w400),
                    SizedBox(height: 15,),
                    Divider(thickness: .5,height: 5,color: greyColor,)
                  ],
                );
              },)
            ],
          ),
        ),
      ),



    );
  }

}

