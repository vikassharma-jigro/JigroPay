import 'package:flutter/material.dart';
import 'package:jigrotech/app_utils/text_widget.dart';
import 'package:jigrotech/main.dart';
class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientAppScaffold(
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          drawer: Drawer(
            backgroundColor: Colors.orange,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                text("Personal", fontSize: 16)
              ],
            ),
          ),
        )
    );
  }
}
