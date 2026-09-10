import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../getx_controller/auth_controller.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  TextEditingController searchController = TextEditingController();
  String selectedFilter = "All";
  Timer? _debounceTimer;

  final List<Map<String, String>> filters = [
    {"label": "All", "type": ""},
    {"label": "Recharges & Bill", "type": "recharge"},
    {"label": "Credit Card Bill", "type": "cc_bill_pay"},
  ];
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getTransactionHistoryApi(context: context, type: "", search: "");
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  String _getCurrentType() {
    var match = filters.firstWhere(
      (element) => element["label"] == selectedFilter,
      orElse: () => {"label": "All", "type": ""},
    );
    return match["type"] ?? "";
  }

  void _onSearchChanged(String val) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      authController.getTransactionHistoryApi(
        context: context,
        type: _getCurrentType(),
        search: val.trim(),
      );
    });
  }

  String _formatAmount(dynamic rawAmount) {
    if (rawAmount == null) return "₹0.00";
    double amount = double.tryParse(rawAmount.toString()) ?? 0.0;
    String val = amount.toStringAsFixed(2);
    List<String> parts = val.split(".");
    String whole = parts[0];
    String res = "";
    int len = whole.length;
    if (len > 3) {
      res = whole.substring(len - 3);
      whole = whole.substring(0, len - 3);
      while (whole.length > 2) {
        res = whole.substring(whole.length - 2) + "," + res;
        whole = whole.substring(0, whole.length - 2);
      }
      if (whole.isNotEmpty) {
        res = whole + "," + res;
      }
    } else {
      res = whole;
    }
    return "₹" + res + "." + parts[1];
  }

  List<dynamic> _getFilteredTransactions(List<dynamic> list) {
    String query = searchController.text.trim().toLowerCase();
    if (query.isEmpty) return list;

    return list.where((item) {
      if (item is! Map) return true;
      String allValues = item.values.map((e) => e?.toString() ?? '').join(' ').toLowerCase();
      return allValues.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: text(
          "History",
          textAlign: TextAlign.center,
          textColor: blackColor,
          fontSize: 18,
          fontFamily: FontFamily.plusJakartaSansBold,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar with Grey Border
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: greyColor, width: 1.0),
              ),
              child: TextField(
                controller: searchController,
                onChanged: _onSearchChanged,
                onSubmitted: (val) {
                  authController.getTransactionHistoryApi(
                    context: context,
                    type: _getCurrentType(),
                    search: val.trim(),
                  );
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: greyColor),
                  //suffixIcon: const Icon(Icons.tune, color: greyColor),
                  hintText: "Search by name and payment",
                  hintStyle: TextStyle(
                    color: greyColor.withOpacity(0.8),
                    fontSize: 14,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          
          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  var filterItem = filters[index];
                  String label = filterItem["label"]!;
                  String type = filterItem["type"]!;
                  bool isSelected = selectedFilter == label;
                  return GestureDetector(
                    onTap: () {
                      if (selectedFilter != label) {
                        setState(() {
                          selectedFilter = label;
                        });
                        authController.getTransactionHistoryApi(
                          context: context,
                          type: type,
                          search: searchController.text.trim(),
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : const Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: text(
                          label,
                          textColor: isSelected ? white : blackColor.withOpacity(0.7),
                          fontSize: 13,
                          fontFamily: isSelected ? FontFamily.plusJakartaSansBold : FontFamily.plusJakartaSansMedium,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Dynamic List View
          Expanded(
            child: Obx(() {
              if (authController.isTransactionLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var historyList = authController.transactionHistoryList;
              var filteredList = _getFilteredTransactions(historyList);

              if (filteredList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 60, color: greyColor),
                      const SizedBox(height: 12),
                      text(
                        "No transaction history found",
                        textColor: greyColor,
                        fontSize: 16,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await authController.getTransactionHistoryApi(context: context);
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    var item = filteredList[index];
                    return _buildTransactionItem(item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(dynamic item) {
    if (item is! Map) return "";

    dynamic rawDate = item['created_at'] ??
        item['date'] ??
        item['created_date'] ??
        item['datetime'] ??
        item['time'] ??
        item['timestamp'] ??
        item['updated_at'];

    if (rawDate == null || rawDate.toString().isEmpty) {
      return "";
    }

    String strDate = rawDate.toString().trim();

    try {
      DateTime? parsedDate = DateTime.tryParse(strDate);
      if (parsedDate != null) {
        return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate.toLocal());
      }
    } catch (_) {}

    if (int.tryParse(strDate) != null) {
      try {
        int ts = int.parse(strDate);
        if (ts < 10000000000) ts *= 1000;
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(ts);
        return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

    List<String> patterns = [
      'yyyy-MM-dd HH:mm:ss',
      'yyyy/MM/dd HH:mm:ss',
      'dd-MM-yyyy HH:mm:ss',
      'dd/MM/yyyy HH:mm:ss',
      'dd-MM-yyyy hh:mm a',
      'dd/MM/yyyy hh:mm a',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'dd/MM/yyyy',
    ];

    for (String pattern in patterns) {
      try {
        DateTime dt = DateFormat(pattern).parse(strDate);
        return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

    return strDate;
  }

  Widget _buildTransactionItem(dynamic item) {
    if (item is! Map) return const SizedBox();

    String consumerNo = item['consumer_number']?.toString() ??
        item['number']?.toString() ??
        item['mobile']?.toString() ??
        "";

    String typeStr = (item['type'] ?? item['opcode'] ?? item['category'] ?? item['biller_id'] ?? '').toString();

    String title = item['category_name']?.toString() ??
        item['biller_name']?.toString() ??
        item['service_name']?.toString() ??
        item['name']?.toString() ??
        item['title']?.toString() ??
        "";

    if (title.isEmpty) {
      if (typeStr.toLowerCase().contains("recharge") || typeStr.toUpperCase() == "RC") {
        title = consumerNo.isNotEmpty ? "Mobile Recharge ($consumerNo)" : "Mobile Recharge";
      } else if (typeStr.toLowerCase().contains("cc_bill_pay") || typeStr.toLowerCase().contains("credit")) {
        title = consumerNo.isNotEmpty ? "Credit Card Bill ($consumerNo)" : "Credit Card Bill";
      } else if (typeStr.toLowerCase().contains("dth")) {
        title = consumerNo.isNotEmpty ? "DTH Recharge ($consumerNo)" : "DTH Recharge";
      } else if (typeStr.toLowerCase().contains("electr")) {
        title = consumerNo.isNotEmpty ? "Electricity Bill ($consumerNo)" : "Electricity Bill";
      } else if (typeStr.toLowerCase().contains("gas")) {
        title = consumerNo.isNotEmpty ? "Gas Bill ($consumerNo)" : "Gas Bill";
      } else if (typeStr.toLowerCase().contains("water")) {
        title = consumerNo.isNotEmpty ? "Water Bill ($consumerNo)" : "Water Bill";
      } else if (consumerNo.isNotEmpty) {
        title = "Payment ($consumerNo)";
      } else {
        title = "Payment Transaction";
      }
    } else if (consumerNo.isNotEmpty && !title.contains(consumerNo)) {
      title = "$title ($consumerNo)";
    }

    String subtitle = _formatDateTime(item);

    dynamic rawAmount = item['amount'] ?? item['paid_amount'] ?? item['total_amount'] ?? 0;
    String status = (item['status'] ?? item['payment_status'] ?? 'Success').toString();
    String type = typeStr.toLowerCase();

    IconData iconData = Icons.receipt_long;
    Color iconColor = primaryColor;

    if (type.contains("electr") || type.contains("light") || type.contains("power")) {
      iconData = Icons.bolt;
      iconColor = Colors.orange;
    } else if (type.contains("mob") || type.contains("recharge") || type.contains("phone")) {
      iconData = Icons.phone_android;
      iconColor = primaryColor;
    } else if (type.contains("dth") || type.contains("cable") || type.contains("tv")) {
      iconData = Icons.tv;
      iconColor = primaryColor;
    } else if (type.contains("card") || type.contains("credit")) {
      iconData = Icons.credit_card;
      iconColor = Colors.purple;
    } else if (type.contains("water") || type.contains("gas")) {
      iconData = Icons.water_drop;
      iconColor = Colors.blue;
    }

    bool isSuccessStatus = status.toLowerCase() == 'success' || status == '1' || status == 'true' || status.toLowerCase() == 'successful';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
                ),
                child: Center(
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
              ),
              const SizedBox(width: 15),
              // Text Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      title,
                      textColor: blackColor,
                      fontSize: 15,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      maxLine: 1,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      text(
                        subtitle,
                        textColor: greyColor,
                        fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansRegular,
                      ),
                    ],
                  ],
                ),
              ),
              // Amount and Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  text(
                    _formatAmount(rawAmount),
                    textColor: isSuccessStatus ? const Color(0xff059669) : Colors.red,
                    fontSize: 15,
                    fontFamily: FontFamily.plusJakartaSansBold,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      text(
                        status,
                        textColor: isSuccessStatus ? const Color(0xff059669) : Colors.red,
                        fontSize: 12,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isSuccessStatus ? Icons.check_circle : Icons.error,
                        size: 12,
                        color: isSuccessStatus ? const Color(0xff059669) : Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade200, thickness: 1, height: 10),
      ],
    );
  }
}
