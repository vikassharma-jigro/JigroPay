import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jigrotech/View/auth_view/useApp_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import '../../app_utils/app_colors.dart';
import '../../app_utils/font_family.dart';
import '../../app_utils/mixin_widget.dart';
import '../../app_utils/text_widget.dart';
import '../../main.dart';

class ScanPhotoScreen extends StatefulWidget {
  const ScanPhotoScreen({super.key});

  @override
  State<ScanPhotoScreen> createState() => _ScanPhotoScreenState();
}

class _ScanPhotoScreenState extends State<ScanPhotoScreen>
    with ImagePickerMixin<ScanPhotoScreen> {
  XFile? _pickedImage; // Store single picked image
  List<XFile>? _pickedImages;

  Future<void> _pickFromCamera() async {
    final image = await pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  // 🖼️ pick from gallery (single)
  Future<void> _pickFromGallery() async {
    final image = await pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImage = image);
    }
  }

  // 📂 pick multiple images
  Future<void> _pickMultiple() async {
    final images = await pickMultiImage();
    if (images != null) {
      setState(() => _pickedImages = images);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios, color: purpleGradientColor),
              ),
              const SizedBox(height: 30),
              _pickedImage == null
                  ? InkWell(
                      onTap: () {
                        _showImagePicker(context);
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsetsGeometry.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(color: purpleGradientColor),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(AppImages.userIcon),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(_pickedImage!.path),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: purpleGradientColor,
                    ),
                    child: text(
                      "1",
                      textColor: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                  ),
                  SizedBox(width: 20),
                  text(
                    "Remove your eye glass(if have any).",
                    textColor: greyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: purpleGradientColor,
                    ),
                    child: text(
                      "2",
                      textColor: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                  ),

                  SizedBox(width: 20),
                  text(
                    "Place your face in photo frame.",
                    textColor: greyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: purpleGradientColor,
                    ),
                    child: text(
                      "3",
                      textColor: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                  ),

                  SizedBox(width: 20),
                  text(
                    "Place your face in photo frame.",
                    textColor: greyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: purpleGradientColor,
                    ),
                    child: text(
                      "4",
                      textColor: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                  ),

                  SizedBox(width: 20),
                  text(
                    "Do not shake your face when capturing photo.",
                    textColor: greyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: purpleGradientColor,
                    ),
                    child: text(
                      "5",
                      textColor: white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.plusJakartaSansBold,
                    ),
                  ),

                  SizedBox(width: 20),
                  text(
                    "Blink your eyes several times to capture photo.",
                    textColor: greyColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.plusJakartaSansMedium,
                  ),
                ],
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 55,
                child: CommonButton(
                  text: "Next",
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UseAppScreen()),
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
}
