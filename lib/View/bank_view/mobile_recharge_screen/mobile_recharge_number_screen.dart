import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' hide PermissionStatus;
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../getx_controller/recharge_controller.dart';
import 'recharge_plan_screen.dart';

class MobileRechargeNumberScreen extends StatefulWidget {
  const MobileRechargeNumberScreen({super.key});

  @override
  State<MobileRechargeNumberScreen> createState() =>
      _MobileRechargeNumberScreenState();
}

class _MobileRechargeNumberScreenState
    extends State<MobileRechargeNumberScreen> {
  final RechargeController rechargeController = Get.put(RechargeController());
  TextEditingController searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _permissionDenied = false;

  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rechargeController.fetchRecentRecharges(context: context);
    });
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
        String number = contact.phones.isNotEmpty
            ? contact.phones.first.number.replaceAll(RegExp(r'\D'), '')
            : '';
        return name.contains(query) || number.contains(query);
      }).toList();
    });
  }

  void _navigateToPlan(String number, String name) async {
    if (_hasNavigated) return;
    _hasNavigated = true;

    FocusManager.instance.primaryFocus?.unfocus();
    // clean number (remove spaces, +91 etc if needed)
    String cleanNumber = number.replaceAll(RegExp(r'\D'), '');
    if (cleanNumber.length > 10) {
      cleanNumber = cleanNumber.substring(cleanNumber.length - 10);
    }

    if (cleanNumber.length == 10) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RechargePlanScreen(
            mobileRechargeNumber: cleanNumber,
            number: cleanNumber,
            contactName: name.isNotEmpty && name != "Manual Entry"
                ? name
                : null,
          ),
        ),
      );
      _hasNavigated = false;
      searchController.clear();
    } else {
      _hasNavigated = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Selected contact does not have a valid 10-digit number",
          ),
        ),
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
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextFormField(
                controller: searchController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: greyColor),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  hintText: "Search by name",
                  hintStyle: TextStyle(
                    color: greyColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  String cleanNumber = value.replaceAll(RegExp(r'\D'), '');
                  if (cleanNumber.length == 10) {
                    _navigateToPlan(cleanNumber, "Manual Entry");
                  }
                },
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
          _buildRecentRecharges(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
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
                        ),
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
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
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
                            _navigateToPlan(
                              contact.phones.first.number,
                              contact.displayName ?? '',
                            );
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

  Widget _buildRecentRecharges() {
    return Obx(() {
      if (searchController.text.isNotEmpty) {
        return const SizedBox.shrink();
      }

      if (rechargeController.isRecentLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }

      var recents = rechargeController.recentRechargesList;
      if (recents.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  "Recent Recharges",
                  textColor: blackColor,
                  fontSize: 16,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600,
                ),
                text(
                  "${recents.length}",
                  textColor: greyColor,
                  fontSize: 13,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 6.0,
              ),
              itemCount: recents.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                var item = recents[index];
                if (item is! Map) return const SizedBox.shrink();

                String rawNumber = item['mobile']?.toString() ??
                    item['mobile_number']?.toString() ??
                    item['number']?.toString() ??
                    item['consumer_number']?.toString() ??
                    item['phone']?.toString() ??
                    item['account']?.toString() ??
                    "";

                String cleanNumber = rawNumber.replaceAll(RegExp(r'\D'), '');
                if (cleanNumber.length > 10) {
                  cleanNumber = cleanNumber.substring(cleanNumber.length - 10);
                }

                String name = item['name']?.toString() ??
                    item['contact_name']?.toString() ??
                    item['customer_name']?.toString() ??
                    item['biller_name']?.toString() ??
                    item['title']?.toString() ??
                    "";

                String operatorName = item['operator']?.toString() ??
                    item['operator_name']?.toString() ??
                    item['company_name']?.toString() ??
                    item['opcode']?.toString() ??
                    "";

                dynamic rawAmount = item['amount'] ??
                    item['paid_amount'] ??
                    item['total_amount'] ??
                    item['plan_amount'];
                String amountStr =
                    (rawAmount != null && rawAmount.toString().isNotEmpty)
                        ? "₹$rawAmount"
                        : "";

                String? logoUrl = item['logo']?.toString() ??
                    item['operator_logo']?.toString() ??
                    item['image']?.toString() ??
                    item['icon']?.toString();

                String displayName =
                    name.isNotEmpty ? name : (cleanNumber.isNotEmpty ? cleanNumber : "Recharge");
                String displaySubtitle = name.isNotEmpty
                    ? (operatorName.isNotEmpty
                        ? "$cleanNumber • $operatorName"
                        : cleanNumber)
                    : operatorName;

                return InkWell(
                  onTap: () {
                    if (cleanNumber.isNotEmpty) {
                      _navigateToPlan(
                        cleanNumber,
                        name.isNotEmpty
                            ? name
                            : (operatorName.isNotEmpty
                                ? operatorName
                                : "Recent Recharge"),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 175,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: primaryColor.withValues(alpha: 0.1),
                          backgroundImage:
                              (logoUrl != null && logoUrl.startsWith("http"))
                                  ? NetworkImage(logoUrl)
                                  : null,
                          child: (logoUrl == null || !logoUrl.startsWith("http"))
                              ? const Icon(
                                  Icons.phone_android,
                                  color: primaryColor,
                                  size: 18,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: blackColor,
                                  fontSize: 13,
                                  fontFamily: FontFamily.plusJakartaSansBold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (displaySubtitle.isNotEmpty)
                                Text(
                                  displaySubtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: greyColor,
                                    fontSize: 11,
                                    fontFamily:
                                        FontFamily.plusJakartaSansRegular,
                                  ),
                                ),
                              if (amountStr.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    amountStr,
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontFamily:
                                        FontFamily.plusJakartaSansBold,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),
        ],
      );
    });
  }
}

