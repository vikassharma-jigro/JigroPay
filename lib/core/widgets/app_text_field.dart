import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';

/// Styled text field for JigroPay.
///
/// Replaces [custom_textFiled.dart] with a consistent, configurable widget.
/// Supports outlined & filled variants, prefix/suffix icons, obscure toggle,
/// input formatters, and validator-compatible error text.
///
/// Usage:
/// ```dart
/// AppTextField(
///   controller: _mobileController,
///   label: 'Mobile Number',
///   keyboardType: TextInputType.phone,
///   validator: InputValidators.mobile,
///   prefixIcon: Icons.phone_outlined,
/// )
/// ```
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.initialValue,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.isPassword = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.filled = false,
    this.fillColor,
    this.borderRadius = 12.0,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.contentPadding,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final bool isPassword;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final bool filled;
  final Color? fillColor;
  final double borderRadius;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final bool autofocus;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: const BorderSide(color: AppColors.lightGrey, width: 1.2),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      borderSide: const BorderSide(color: AppColors.errorBright, width: 1.5),
    );

    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      obscureText: widget.isPassword && _obscure,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      style: widget.textStyle ?? AppTypography.inputText,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: AppTypography.inputLabel,
        hintStyle: AppTypography.inputHint,
        errorStyle: AppTypography.inputError,
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: widget.filled,
        fillColor: widget.fillColor ??
            (widget.filled ? AppColors.lightWhite1 : null),
        counterText: '',

        // Prefix
        prefixIcon: widget.prefixWidget ??
            (widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: AppColors.grey)
                : null),

        // Suffix
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.grey,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : widget.suffixWidget ??
                (widget.suffixIcon != null
                    ? Icon(widget.suffixIcon, size: 20, color: AppColors.grey)
                    : null),

        // Borders
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: border.copyWith(
          borderSide:
              const BorderSide(color: AppColors.lightGrey, width: 0.8),
        ),
      ),
    );
  }
}

/// Read-only display field that looks like [AppTextField].
/// Used for showing fetched data (bill amount, consumer name) in the UI.
class AppReadOnlyField extends StatelessWidget {
  const AppReadOnlyField({
    super.key,
    required this.label,
    required this.value,
    this.prefixIcon,
    this.borderRadius = 12.0,
    this.filled = true,
  });

  final String label;
  final String value;
  final IconData? prefixIcon;
  final double borderRadius;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      initialValue: value,
      readOnly: true,
      filled: filled,
      fillColor: AppColors.lightWhite1,
      prefixIcon: prefixIcon,
      borderRadius: borderRadius,
    );
  }
}
