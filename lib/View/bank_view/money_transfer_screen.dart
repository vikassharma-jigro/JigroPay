import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'companey_recharge_screen.dart';


class MoneyTransferScreen extends StatefulWidget {
  const MoneyTransferScreen({super.key,});

  @override
  State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
}


class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
TextEditingController searchController = TextEditingController();
List<Contact> contacts = [];
List<Contact> filteredContacts = [];

  @override
  void initState() {
    getContacts();
    super.initState();
  }

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
void filterSearch(String query) {
  List<Contact> results = [];

  if (query.isEmpty) {
    results = contacts;
  } else {
    results = contacts
        .where((c) =>
        c.displayName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  setState(() {
    filteredContacts = results;
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
            Expanded(
              child: text("Mobile Recharge",
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

      body:contacts.isEmpty?Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) => filterSearch(value),
                onSubmitted: (v) => filterSearch(v),
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
                  prefixIcon: GestureDetector(
                    onTap: () {
                      filterSearch(searchController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 10, bottom: 5, top: 5),
                      child: const Icon(Icons.search, color: greyColor),
                    ),
                  ),
                  fillColor: lightGreyColor,
                  hintText: "Search by name",
                  hintStyle: const TextStyle(fontSize: 16.0, color: blackColor, fontFamily: 'Roboto-Light'),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),

              SizedBox(height: 10,),
              ListView.builder(
                itemCount: filteredContacts.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final contact = filteredContacts[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CompanyRechargeScreen(
                        mobileRechargeNumber:contact.displayName,
                        photo: contact.photo.toString(),
                      number: contact.phones.first.number,
                      ),));
                    },
                    child: ListTile(
                      leading: (contact.photo != null)
                          ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.photo!))
                          : const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(contact.displayName),
                      subtitle: Text(
                        contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : 'No number',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),



    );
  }

}




