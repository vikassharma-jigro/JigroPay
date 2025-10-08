import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:jigrotech/app_utils/font_family.dart";
import "app_colors.dart";

class CustomRoundTextField extends StatelessWidget {
  final Icon? icon;
  final String? iconAsset;
  final String? hintText;
  final String? initialValue;

  String? Function(String? val)? validator;
  //final Function()? ;
  String? Function(String? val)? onSaved;
  //final Function()? onSaved,
  final Function(String text)? onChanged;
  final bool? isPassword;
  final bool? isEmail;
  final bool? enable;
  final bool? readOnly;
  final int? minLines;
  final int? maxLength;
  final double? hintSize;
  final double? textSize;
  final EdgeInsetsGeometry? padding;
  final int? maxLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? hintColor;
  final Function()? onTap;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  bool? autofocus;
  final double? borderRadius;
  TextCapitalization? textCapitalization;

  CustomRoundTextField({
    this.icon,
    this.hintText,
    this.maxLength,
    this.fillColor,
    this.hintColor = blackColor,
    this.padding = const EdgeInsets.fromLTRB(0, 0, 0, 15),
    this.isEmail = false,
    this.validator,
    this.onSaved,
    this.borderRadius = 6.0,
    this.onChanged,
    this.isPassword = false,
    this.keyboardType,
    this.controller,
    this.enable,
    this.minLines = 1,
    this.maxLines = 1,
    this.focusNode,
    this.readOnly = false,
    this.initialValue,
    this.onTap,
    this.inputFormatters,
    this.iconAsset = "",
    this.suffixIcon,
    IconButton,
    this.prefixIcon,
    this.hintSize = 16,
    this.textSize = 16,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: TextFormField(
        textCapitalization: textCapitalization!,
        //style: AppTextStyles.mediumStyle(textSize!, black),
        maxLength: maxLength,
        autofocus: autofocus!,
        readOnly: readOnly!,
        controller: controller,
        enabled: enable,
        minLines: minLines,
        maxLines: maxLines,
        focusNode: focusNode,
        initialValue: initialValue,
        onTap: onTap,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          border: InputBorder.none,

          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: purpleGradientColor),
            borderRadius: BorderRadius.circular(6.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: purpleGradientColor),
            borderRadius: BorderRadius.circular(6.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: purpleGradientColor),
            borderRadius: BorderRadius.circular(6.0),
          ),
          disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: purpleGradientColor),
        borderRadius: BorderRadius.circular(6.0),
      ),
          suffixIconConstraints:
          const BoxConstraints(minHeight: 20, minWidth: 20),
          counterText: "",
          prefixIconConstraints: const BoxConstraints(minHeight: 30, minWidth: 30),
          // labelText: "",
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14,fontFamily: FontFamily.plusJakartaSansRegular,fontWeight: FontWeight.w500),
          errorMaxLines: 4,
          contentPadding: const EdgeInsets.only(left: 2, top: 3.0, bottom: 15),
          filled: true,
          fillColor: fillColor,
        ),
        obscureText: isPassword! ? true : false,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autocorrect: false,
      )
    );
  }
}
