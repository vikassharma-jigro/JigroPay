import 'package:flutter/material.dart';
import 'app_colors.dart';

/// JigroPay typography system.
///
/// Font family: **Outfit** (Black / Bold / Medium / Regular)
/// Variable names now match the actual font values they reference.
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTypography.h1)
/// Text('Body', style: AppTypography.body1)
/// ```
abstract final class AppTypography {
  // ── Font family name constants (match pubspec.yaml families) ─────────────────
  static const String outfitBlack = 'Outfit-Black';
  static const String outfitBold = 'Outfit-Bold';
  static const String outfitMedium = 'Outfit-Medium';
  static const String outfitRegular = 'Outfit-Regular';

  // ── Headings ─────────────────────────────────────────────────────────────────

  /// Large display heading — splash / onboarding hero text
  static const TextStyle display = TextStyle(
    fontFamily: outfitBold,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    letterSpacing: -0.5,
  );

  /// Page-level heading
  static const TextStyle h1 = TextStyle(
    fontFamily: outfitBold,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
    letterSpacing: -0.3,
  );

  /// Section heading
  static const TextStyle h2 = TextStyle(
    fontFamily: outfitBold,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// Card / widget title
  static const TextStyle h3 = TextStyle(
    fontFamily: outfitMedium,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  // ── Body ──────────────────────────────────────────────────────────────────────

  /// Primary body text
  static const TextStyle body1 = TextStyle(
    fontFamily: outfitRegular,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.text,
    height: 1.5,
  );

  /// Secondary / helper body text
  static const TextStyle body2 = TextStyle(
    fontFamily: outfitRegular,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
    height: 1.4,
  );

  // ── Labels & Captions ────────────────────────────────────────────────────────

  static const TextStyle label = TextStyle(
    fontFamily: outfitMedium,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: outfitRegular,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // ── Buttons ───────────────────────────────────────────────────────────────────

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: outfitBold,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: outfitMedium,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: outfitMedium,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.white,
  );

  // ── Amounts / Numbers ─────────────────────────────────────────────────────────

  /// Large monetary amount display
  static const TextStyle amountLarge = TextStyle(
    fontFamily: outfitBold,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle amountMedium = TextStyle(
    fontFamily: outfitBold,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle amountSmall = TextStyle(
    fontFamily: outfitMedium,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  // ── App Bar ───────────────────────────────────────────────────────────────────

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: outfitBold,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  // ── Input Fields ──────────────────────────────────────────────────────────────

  static const TextStyle inputText = TextStyle(
    fontFamily: outfitRegular,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle inputHint = TextStyle(
    fontFamily: outfitRegular,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: outfitMedium,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const TextStyle inputError = TextStyle(
    fontFamily: outfitRegular,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.errorBright,
  );
}
