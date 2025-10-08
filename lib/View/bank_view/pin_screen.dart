// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:jigrotech/app_utils/app_images.dart';
// import '../../app_utils/app_colors.dart';
// import '../../app_utils/font_family.dart';
// import '../../app_utils/text_widget.dart';
// import '../../main.dart';
//
//
// class PinScreen extends StatefulWidget {
//   final String? bankName;
//   const PinScreen({super.key,this.bankName});
//
//   @override
//   State<PinScreen> createState() => _PinScreenState();
// }
//
//
// class _PinScreenState extends State<PinScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return GradientAppScaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title:   Row(
//           children: [
//             InkWell(
//               onTap: (){
//                 Navigator.pop(context);
//               },
//               child:  Icon(Icons.arrow_back_ios,color: white,),
//             ),
//             // SizedBox(width: 10,),
//           ],
//         ),
//       ),
//
//       body: Container(
//         color: lightGreyColor,
//         width: double.infinity,
//         height: double.infinity,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     text(widget.bankName??"",
//                         textAlign: TextAlign.center,
//                         isCentered: true,
//                         textColor:blackColor,fontSize: 15,
//                         fontFamily: FontFamily.plusJakartaSansMedium,
//                         fontWeight: FontWeight.w500),
//
//
//                     Column(
//
//
//                       children: [
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: blackColor
//                           ),
//                           child: text("UPI",
//                               textAlign: TextAlign.center,
//                               isCentered: true,
//                               textColor:white,fontSize: 15,
//                               fontFamily: FontFamily.plusJakartaSansMedium,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         SizedBox(height: 5,),
//                         text("UNIFIED PAYMENTS\n INTERFACE",
//                             textColor:greyColor,fontSize: 13,
//                             fontFamily: FontFamily.plusJakartaSansMedium,
//                             fontWeight: FontWeight.w500),
//                       ],
//                     ),
//                   ],
//                 ),
//
//                 Divider(thickness: .6,color: greyColor,),
//                 SizedBox(height: 55,),
//                 text("ENTER 4-DIGIT UPI PIN",
//                     textColor:blackColor,fontSize: 18,
//                     fontFamily: FontFamily.plusJakartaSansBold,
//                     fontWeight: FontWeight.w700),
//                 SizedBox(height: 15,),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//
//
//
//     );
//   }
//
// }
//


import 'package:flutter/material.dart';
import 'package:jigrotech/View/bank_view/payment_success_screen.dart';

import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'mobile_recharge_screen/mobile_recharge_success_screen.dart';

class UpiPinScreen extends StatefulWidget {
  final String? bankName;
  final  bool? isMobileRecharge;
  const UpiPinScreen({super.key,this.bankName,this.isMobileRecharge});

  @override
  State<UpiPinScreen> createState() => _UpiPinScreenState();
}

class _UpiPinScreenState extends State<UpiPinScreen> {
  String pin = '';

  void addDigit(String digit) {
    if (pin.length < 6) {
      setState(() {
        pin += digit;
      });

      if (pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 200), () {
          // TODO: Handle PIN submit (API call or verification)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Entered PIN: $pin')),
          );
        });
      }
    }
  }

  void deleteDigit() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  Widget buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool filled = index < pin.length;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? Colors.deepPurple : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  Widget buildNumberButton(String number) {
    return GestureDetector(
      onTap: () => addDigit(number),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: text(
          number,
          fontSize: 18,
          fontFamily: FontFamily.plusJakartaSansBold,fontWeight: FontWeight.w600,
          textColor: blackColor
        ),
      ),
    );
  }

  Widget buildKeypad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['←', '0', '✓'],
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((label) {
                if (label == '←') {
                  return GestureDetector(
                    onTap: deleteDigit,
                    child: const Icon(Icons.backspace_outlined, size: 28),
                  );
                } else if (label == '✓') {
                  return GestureDetector(
                    onTap: () {
                      if (pin.length == 4) {
                       widget.isMobileRecharge==true?
                       Navigator.push(context, MaterialPageRoute(builder: (context) => MobileRechargeSuccessScreen(),)):
                       Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentSuccessScreen(),));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PIN Submitted: $pin')),
                        );
                      }
                    },
                    child: const Icon(Icons.check_circle,
                        color: purpleGradientColor, size: 34),
                  );
                } else {
                  return buildNumberButton(label);
                }
              }).toList(),
            ),
          ),
      ],
    );
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
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
          text(widget.bankName??"",
                        textAlign: TextAlign.start,
                        isCentered: true,
                        textColor:blackColor,fontSize: 15,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w500),
            const SizedBox(height: 30),
             text(
              "ENTER 4-DIGIT UPI PIN",
              fontWeight: FontWeight.w600,fontFamily: FontFamily.plusJakartaSansBold,
               fontSize: 18,textColor: blackColor
            ),
            buildPinDots(),
            const SizedBox(height: 40),
            buildKeypad(),
          ],
        ),
      ),
    );
  }
}

