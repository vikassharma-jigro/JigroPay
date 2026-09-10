import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigrotech/View/fast_tag_view/fast_tag_topamount_screen.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import 'package:get/get.dart';
import '../../../getx_controller/recharge_controller.dart';

class FastTagVehicleScreen extends StatefulWidget {
  final String? fastTagBankName;
  final String? fastTagBankOpcode;

  const FastTagVehicleScreen({super.key, this.fastTagBankName, this.fastTagBankOpcode});

  @override
  State<FastTagVehicleScreen> createState() => _FastTagVehicleScreenState();
}


class _FastTagVehicleScreenState extends State<FastTagVehicleScreen> {
  TextEditingController vehicleController = TextEditingController();
  final RechargeController rechargeController = Get.put(RechargeController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: blackColor),
            ),
            Expanded(
              child: text(
                "${widget.fastTagBankName}",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: blackColor,
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
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: 55,
          child: CommonButton(
            text: "Confirm",
            textColor: white,
            borderRadius: BorderRadiusGeometry.circular(15),
            gradient: const LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            fontWeight: FontWeight.w600,
            fontFamily: FontFamily.plusJakartaSansBold,
            fontSize: 18.0,
            onPressed: () async {
              if (vehicleController.text.trim().isEmpty) {
                // Should show error toast ideally
                return;
              }
              if (widget.fastTagBankOpcode != null) {
                var response = await rechargeController.fetchFastagBill(
                  context: context, 
                  consumerId: vehicleController.text.trim(), 
                  opcode: widget.fastTagBankOpcode!
                );
                
                if (response != null && (response['status'] == true || response['status'] == 'Success')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FastTagTopAmountScreen(
                        fastTagBankName: widget.fastTagBankName,
                        billData: response['data'] ?? response,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text(
                "Vehicle Number ",
                textColor: blackColor,
                fontSize: 16,
                fontFamily: FontFamily.plusJakartaSansMedium,
                fontWeight: FontWeight.w600,
              ),

              SizedBox(height: 10),
              TextField(
                controller: vehicleController,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) => TextEditingValue(
                      text: newValue.text.toUpperCase(),
                      selection: newValue.selection,
                    ),
                  ),
                ],
                onChanged: (i) {},
                onSubmitted: (v) {},
                //controller: vehicleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // Other decoration properties...
                  filled: true,
                  fillColor: white,
                  hintText: "RJ14AB1234",
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
              // SizedBox(height: 10),
              // Center(
              //   child: text(
              //     "Please enter the vehicle number in capital letters",
              //     textAlign: TextAlign.center,
              //     isCentered: true,
              //     textColor: greyColor,
              //     fontSize: 12,
              //     fontFamily: FontFamily.plusJakartaSansRegular,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),

              SizedBox(height: 10),
              Card(
                color: white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: text(
                      "By proceeding futher, you allow Jigropay to fetch  your current and future balances  and remind you",
                      textAlign: TextAlign.center,
                      isCentered: true,
                      textColor: greyColor,
                      fontSize: 12,
                      fontFamily: FontFamily.plusJakartaSansRegular,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
