
import 'package:flutter/material.dart';
import '../../../app_utils/app_colors.dart';
import '../../../app_utils/font_family.dart';
import '../../../app_utils/text_widget.dart';
import '../../../main.dart';



class FastTagTopAmountScreen extends StatefulWidget {
  final String? fastTagBankName;

  const FastTagTopAmountScreen({super.key,this.fastTagBankName});

  @override
  State<FastTagTopAmountScreen> createState() => _FastTagTopAmountScreenState();
}


class _FastTagTopAmountScreenState extends State<FastTagTopAmountScreen> {

  TextEditingController vehicleController = TextEditingController();

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
              child: text("${widget.fastTagBankName} FASTAG",
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 Important for fitting content at bottom
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            text("By proceeding futher, you allow Jigropay to fetch  your current and future balances  and remind you.",
            textColor: blackColor,
              fontSize: 13,fontFamily: FontFamily.plusJakartaSansRegular,
              fontWeight: FontWeight.w400
            ),
            SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 55,
              child: CommonButton(
                  text: "Confirm",
                  textColor: white,
                  borderRadius: BorderRadiusGeometry.circular(15),
                  gradient: const LinearGradient(
                    colors: [pinkColor, purpleGradientColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontSize:18.0,
                  onPressed: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
                  }



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
              Divider(height: 10,thickness: .5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text("Customer Name",
                      textColor:greyColor,fontSize: 11,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w600),

                  text("LUCKY PATHAK",
                      textColor:greyColor,fontSize: 11,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w600),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text("FASTag Balance ",
                      textColor:greyColor,fontSize: 11,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w600),

                  text("675.00",
                      textColor:greyColor,fontSize: 11,
                      fontFamily: FontFamily.plusJakartaSansMedium,
                      fontWeight: FontWeight.w600),
                ],
              ),
              SizedBox(height: 10,),
              Divider(height: 10,thickness: .5,),
              SizedBox(height: 20,),
              text("Top-up amount ",
                  textAlign: TextAlign.center,
                  isCentered: true,
                  textColor:blackColor,fontSize: 18,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600),

              SizedBox(height: 10,),
              TextField(
                controller: vehicleController,
                keyboardType: TextInputType.number,
                onChanged:(i){

                },
                // filterSearch,
                // });

                onSubmitted: (v) {

                },
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
                  hintText: "Top-up amount",
                  hintStyle: const TextStyle(fontSize: 16.0, color: blackColor, fontFamily: FontFamily.plusJakartaSansRegular),
                  contentPadding: const EdgeInsets.only(top: 5, left: 10, bottom: 5, right: 0),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: pinkColor)
                      ),
                      child: Center(
                        child: text("₹500",
                        textColor: blackColor,
                          isCentered: true,
                          textAlign: TextAlign.center,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                },),
              )
            ],
          ),
        ),
      ),



    );
  }

}




