import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jigrotech/View/dashdoard_view/bottom_navigation_bar_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/mixin_widget.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';
import 'package:image_picker/image_picker.dart';

class KycDocumentScreen extends StatefulWidget {
  const KycDocumentScreen({super.key});

  @override
  State<KycDocumentScreen> createState() => _KycDocumentScreenState();
}

class _KycDocumentScreenState extends State<KycDocumentScreen>
    with ImagePickerMixin<KycDocumentScreen> {
  XFile? _pickedImage; // Store single picked image
  XFile? _pickedBackImage; // Store single picked image

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickFromCamera() async {
    final image = await pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _pickedImage = image);
      setState(() => _pickedBackImage = image);
    }
  }

  // 🖼️ pick from gallery (single)
  Future<void> _pickFromGallery() async {
    final image = await pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = image);
      setState(() => _pickedBackImage = image);
    }
  }

  void _showImagePicker(context) {
    // FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  _pickFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
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
            // SizedBox(width: 10,),
            Expanded(
              child: text(
                "KYC Verification",
                textAlign: TextAlign.center,
                isCentered: true,
                textColor: white,
                fontSize: 18,
                fontFamily: FontFamily.plusJakartaSansBold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(child: Image.asset(AppImages.splashIcon, height: 100)),
              const SizedBox(height: 30),
              Center(
                child: text(
                  "National ID",
                  isCentered: true,
                  textAlign: TextAlign.center,
                  textColor: blackColor,
                  fontSize: 22,
                  fontFamily: FontFamily.plusJakartaSansBold,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 5),
              Center(
                child: text(
                  "Scan the front side of NID card with camera",
                  textColor: greyColor,
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w400,
                ),
              ),

              SizedBox(height: 20),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  _pickedImage == null
                      ? Image.asset(AppImages.documentIcon, fit: BoxFit.cover)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_pickedImage!.path),
                            width: 400,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: purpleGradientColor,
                        ),
                        child: Icon(Icons.camera_alt_outlined, color: white),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Center(
                child: text(
                  "Scan the back side of NID card with camera",
                  textColor: greyColor,
                  fontSize: 12,
                  fontFamily: FontFamily.plusJakartaSansMedium,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _pickedBackImage == null
                      ? Image.asset(AppImages.documentIcon, fit: BoxFit.cover)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_pickedBackImage!.path),
                            width: 400,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    right: 20,
                    child: InkWell(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: purpleGradientColor,
                        ),
                        child: Icon(Icons.camera_alt_outlined, color: white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Continue",
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
                  onPressed: () {
                    // if(nameController.text.isEmpty){
                    //   ShowAlertDialog().showErrorAlert(context, "Please Enter Your Full Name");
                    // }else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameController.text)) {
                    //   ShowAlertDialog().showErrorAlert(context, "Please enter valid first name");
                    // }else if(emailNumberController.text.isEmpty){
                    //   ShowAlertDialog().showErrorAlert(context, "Please Enter Your Email");
                    // }else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailNumberController.text)) {
                    //   ShowAlertDialog().showErrorAlert(context, "Please enter valid email address");
                    // }else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailNumberController.text)) {
                    //   ShowAlertDialog().showErrorAlert(context, "Please enter valid email address");
                    // }else if(phoneController.text.isEmpty){
                    //   ShowAlertDialog().showErrorAlert(context, "Please Enter Your Contact Number");
                    // }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(),
                      ),
                    );
                    // }
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
