import 'package:flutter/material.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';

class CableAmountScreen extends StatefulWidget {
  final String? cableServiceName;
  const CableAmountScreen({super.key, this.cableServiceName});

  @override
  State<CableAmountScreen> createState() => _CableAmountScreenState();
}

class _CableAmountScreenState extends State<CableAmountScreen> {
  TextEditingController customerAmountController = TextEditingController();
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
                widget.cableServiceName ?? "",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text(
                "We'll save your details for future payments. You can always go to Bills to pay your upcoming dues.",
                isCentered: true,
                fontSize: 14,
                textColor: greyColor,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.plusJakartaSansRegular,
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                text: "Pay Bill",
                textColor: white,
                gradient: const LinearGradient(
                  colors: [pinkColor, purpleGradientColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontSize: 16.0,

                //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                //borderRadius: BorderRadius.circular(40.0),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                "Enter your Amount to retrieve your account details.",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansRegular,
                fontWeight: FontWeight.w400,
              ),

              SizedBox(height: 30),
              text(
                "Amount",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 10),
              TextField(
                controller: customerAmountController,
                onChanged: (i) {},

                onSubmitted: (v) {},

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
                  fillColor: white,
                  hintText: "Amount",
                  hintStyle: const TextStyle(
                    fontSize: 16.0,
                    color: blackColor,
                    fontFamily: FontFamily.plusJakartaSansRegular,
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 5,
                    left: 10,
                    bottom: 5,
                    right: 0,
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: purpleGradientColor),
                        ),
                        child: Center(
                          child: text(
                            "₹68,151.62",
                            textColor: blackColor,
                            fontSize: 16,
                            fontFamily: FontFamily.plusJakartaSansMedium,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
