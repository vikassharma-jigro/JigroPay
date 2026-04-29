import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'font_family.dart';


Widget text(String text,
    {double fontSize = 10,
      textColor = white,
      String fontFamily = FontFamily.plusJakartaSansRegular,
      FontWeight fontWeight = FontWeight.normal,
      FontStyle fontStyle = FontStyle.normal,
      textAlign = TextAlign.center,
      bool isCentered = false,
      int maxLine = 200,
      bool lineThrough = false,
      double latterSpacing = 0.0,
      bool textAllCaps = false,
      bool isLongText = false}) {
  return Text(textAllCaps ? text.toUpperCase() : text,
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      maxLines: isLongText ? null : maxLine,overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: textColor,
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          decoration:
          lineThrough ? TextDecoration.lineThrough : TextDecoration.none,
          // height: 1.5,
          letterSpacing: latterSpacing));
}

class CommonButton extends StatelessWidget {
  final String text;
  final String fontFamily;
  final VoidCallback onPressed;
  final FontWeight fontWeight;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final Gradient gradient;

  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.fontFamily,
    required this.fontWeight,
    this.textColor = Colors.white,
    this.fontSize = 16.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.gradient = const LinearGradient(
      colors: [Color(0xFFFF5B9B), Color(0xFF7834EB)], // pink to purple
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius as BorderRadius?,
          onTap: onPressed,
          child: Padding(
            padding: padding,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
