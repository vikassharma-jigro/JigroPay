import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' hide PermissionStatus;
import 'package:permission_handler/permission_handler.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';
import 'recharge_plan_screen.dart';

class MobileRechargeNumberScreen extends StatefulWidget {
  const MobileRechargeNumberScreen({super.key});

  @override
  State<MobileRechargeNumberScreen> createState() => _MobileRechargeNumberScreenState();
}

class _MobileRechargeNumberScreenState extends State<MobileRechargeNumberScreen> {
  TextEditingController searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    searchController.addListener(() {
      _filterContacts();
    });
  }

  Future<void> _fetchContacts() async {
    if (!await Permission.contacts.request().isGranted) {
      setState(() {
        _permissionDenied = true;
        _isLoading = false;
      });
      return;
    }

    List<Contact> contacts = await FlutterContacts.getAll(
      properties: {ContactProperty.phone, ContactProperty.photoThumbnail},
    );
    setState(() {
      _contacts = contacts;
      _filteredContacts = contacts;
      _isLoading = false;
    });
  }

  void _filterContacts() {
    String query = searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        String name = (contact.displayName ?? '').toLowerCase();
        String number = contact.phones.isNotEmpty ? contact.phones.first.number.replaceAll(RegExp(r'\D'), '') : '';
        return name.contains(query) || number.contains(query);
      }).toList();
    });
  }

  void _navigateToPlan(String number, String name) {
    FocusManager.instance.primaryFocus?.unfocus();
    // clean number (remove spaces, +91 etc if needed, or just let the API handle it)
    String cleanNumber = number.replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.length > 10) {
      cleanNumber = cleanNumber.substring(cleanNumber.length - 10);
    }
    
    if (cleanNumber.length == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RechargePlanScreen(
            mobileRechargeNumber: cleanNumber,
            number: cleanNumber,
            contactName: name.isNotEmpty && name != "Manual Entry" ? name : null,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Selected contact does not have a valid 10-digit number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            Expanded(
              child: text(
                "Mobile Recharge",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 24),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: greyColor),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  hintText: "Search by number or name",
                  hintStyle: TextStyle(
                    color: greyColor, 
                    fontFamily: FontFamily.plusJakartaSansRegular, 
                    fontSize: 14,
                  ),
                ),
                onFieldSubmitted: (value) {
                  // Allow manual entry if 10 digits
                  String cleanNumber = value.replaceAll(RegExp(r'\D'), '');
                  if (cleanNumber.length == 10) {
                    _navigateToPlan(cleanNumber, "Manual Entry");
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: text(
              "Recent Accounts & Contacts",
              textColor: blackColor,
              fontSize: 16,
              fontFamily: FontFamily.plusJakartaSansBold,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _permissionDenied
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Contact permission denied"),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () => openAppSettings(),
                              child: Text("Open Settings"),
                            )
                          ],
                        ),
                      )
                    : _filteredContacts.isEmpty
                        ? Center(child: Text("No contacts found"))
                        : ListView.builder(
                            itemCount: _filteredContacts.length,
                            itemBuilder: (context, index) {
                              Contact contact = _filteredContacts[index];
                              String number = contact.phones.isNotEmpty 
                                  ? contact.phones.first.number 
                                  : "No number";
                                  
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  backgroundImage: contact.photo?.thumbnail != null 
                                      ? MemoryImage(contact.photo!.thumbnail!) 
                                      : null,
                                  child: contact.photo?.thumbnail == null 
                                      ? Icon(Icons.person, color: Colors.grey)
                                      : null,
                                ),
                                title: text(
                                  contact.displayName ?? '',
                                  textColor: blackColor,
                                  fontSize: 16,
                                  fontFamily: FontFamily.plusJakartaSansMedium,
                                ),
                                subtitle: text(
                                  number,
                                  textColor: greyColor,
                                  fontSize: 14,
                                  fontFamily: FontFamily.plusJakartaSansRegular,
                                ),
                                onTap: () {
                                  if (contact.phones.isNotEmpty) {
                                    _navigateToPlan(contact.phones.first.number, contact.displayName ?? '');
                                  }
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
