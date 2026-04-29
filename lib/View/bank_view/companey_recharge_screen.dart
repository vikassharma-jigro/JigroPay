import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'mobile_recharge_screen/recharge_plan_screen.dart';

class CompanyRechargeScreen extends StatefulWidget {
  final String? mobileRechargeNumber;
  final String? photo;
  final String? number;
  const CompanyRechargeScreen({
    super.key,
    this.mobileRechargeNumber,
    this.photo,
    this.number,
  });

  @override
  State<CompanyRechargeScreen> createState() => _CompanyRechargeScreenState();
}

class _CompanyRechargeScreenState extends State<CompanyRechargeScreen> {
  String? _selectValue;
  List<String> options = [
    "Jio Postpaid",
    "Airtel Postpaid",
    "VI Postpaid",
    "BSNL Postpaid",
    "Jio Fiber",
    "Airtel Broadband",
    "VI Data",
    "BSNL Fiber",
    "Jio Business",
    "Airtel Office",
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),
            Expanded(
              child: text(
                "Mobile Recharge",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: white,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
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
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: MemoryImage(
                      base64Decode(widget.photo ?? ""),
                    ),
                  ),

                  SizedBox(width: 20),
                  text(
                    widget.mobileRechargeNumber ?? "",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: blackColor,
                    fontSize: 18,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(width: 10),
                  text(
                    widget.number ?? "",
                    textAlign: TextAlign.center,
                    isCentered: true,
                    textColor: blackColor,
                    fontSize: 16,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              Divider(thickness: .3, color: greyColor),
              SizedBox(height: 10),
              text(
                "Select your Operator",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 15),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: options.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String item = options[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppImages.rajImage),
                            SizedBox(width: 20),
                            text(
                              item,
                              textAlign: TextAlign.center,
                              isCentered: true,
                              textColor: blackColor,
                              fontSize: 16,
                              fontFamily: FontFamily.plusJakartaSansMedium,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Radio<String>(
                          value: item,
                          activeColor: pinkColor,
                          groupValue: _selectValue,
                          onChanged: (value) {
                            setState(() => _selectValue = value);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RechargePlanScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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
