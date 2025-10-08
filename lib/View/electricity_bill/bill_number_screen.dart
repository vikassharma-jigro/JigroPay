
import 'package:flutter/material.dart';

import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class BillNumberScreen extends StatefulWidget {
final String? billServiceName;
  const BillNumberScreen({super.key,this.billServiceName});

  @override
  State<BillNumberScreen> createState() => _BillNumberScreenState();
}


class _BillNumberScreenState extends State<BillNumberScreen> {

  TextEditingController billNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
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
              child: text("Pay Bill",
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Center(
                child: Card(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: text(widget.billServiceName??"",
                        textColor:blackColor,fontSize: 16,
                        fontFamily: FontFamily.plusJakartaSansMedium,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 40,),
              text("Bill No",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:blackColor,fontSize: 20,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),

              SizedBox(height: 10,),
              TextField(
                controller: billNumberController,
                onChanged:(i){

                },
                // filterSearch,
                // });

                onSubmitted: (v) {

                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: purpleGradientColor),
                    borderRadius: BorderRadius.circular(5),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: purpleGradientColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: purpleGradientColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  filled: true,
                  fillColor: white,
                  hintText: "Bill No.",
                  hintStyle: const TextStyle(fontSize: 16.0, color: blackColor, fontFamily: FontFamily.plusJakartaSansRegular),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
              SizedBox(height: 10,),
              text("Enter Biller Name or Biller Number",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:greyColor,fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansRegular,
                  fontWeight: FontWeight.w600),

              const SizedBox(height: 50,),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                    text: "Next ",
                    textColor: white,
                    gradient: const LinearGradient(
                      colors: [pinkColor, purpleGradientColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.plusJakartaSansBold,
                    fontSize:16.0,
                    //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    //borderRadius: BorderRadius.circular(40.0),

                    onPressed: (){

                    }



                ),
              ),
            ],
          ),
        ),
      ),



    );
  }

}




