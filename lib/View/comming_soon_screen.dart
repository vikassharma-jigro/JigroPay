import 'package:flutter/material.dart';
import 'package:jigrotech/View/auth_view/welcome_screen.dart';
import 'package:jigrotech/app_utils/app_images.dart';
import 'package:jigrotech/app_utils/text_widget.dart';

import '../app_utils/app_colors.dart';
import '../app_utils/font_family.dart';
import '../main.dart';

class CommingSoonScreen extends StatefulWidget {
  const CommingSoonScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CommingSoonScreenState();
}

class _CommingSoonScreenState extends State<CommingSoonScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: white),
            ),

            // SizedBox(width: 10,),
          ],
        ),
      ),
      body: Center(
        child: Container(child: Image.asset(AppImages.inProgressImage)),
      ),
    );
  }
}
