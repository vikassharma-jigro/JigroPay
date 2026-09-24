import 'package:flutter/material.dart';

/// JigroPay color palette — single source of truth.
///
/// Brand primary: deep purple [AppColors.primary]
/// Brand secondary: vivid magenta [AppColors.secondary]
abstract final class AppColors {
  // ── Brand ───────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xff8c2ac4);
  static const Color secondary = Color(0xffe81ecd);
  static const Color primaryGradientEnd = Color(0xff7834eb);

  /// Gradient used on buttons, cards and active tabs.
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradientVertical = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Neutrals ─────────────────────────────────────────────────────────────────
  static const Color white = Color(0xffFFFFFF);
  static const Color black = Color(0xff212121);
  static const Color grey = Color(0xff6e6e6e);
  static const Color text = Color(0xff4d4d4d);
  static const Color lightGrey = Color(0xffe5e7eb);
  static const Color lightWhite = Color(0xffd7cece);
  static const Color lightWhite1 = Color(0xfff3f4f6);
  static const Color light = Color(0xfff9fafb);
  static const Color border = Color(0xffe5e7eb);

  // ── Accent ───────────────────────────────────────────────────────────────────
  static const Color blue = Color(0xff1b467d);
  static const Color blue1 = Color(0xff2563eb);
  static const Color pink = Color(0xffc882fd);
  static const Color darkPink = Color(0xff945fd0);
  static const Color dark = Color(0xff832894);
  static const Color orange = Color(0xfff69f5d);
  static const Color yellow = Color(0xfffacc15);
  static const Color electricPurple = Color(0xff6e2ae9);
  static const Color lightBtn = Color(0xffba75fc);
  static const Color lightBtn1 = Color(0xff7531ea);
  static const Color lightPurple = Color(0xffc882fd);
  static const Color asma = Color(0xffe0f2fe);

  // ── Semantic ─────────────────────────────────────────────────────────────────
  static const Color error = Color(0xff6f0000);
  static const Color errorBright = Color(0xffdc2626);
  static const Color lightError = Color(0xfffee2e2);
  static const Color success = Color(0xff22c55e);
  static const Color lightSuccess = Color(0xffdcfce7);
  static const Color lightGreen = Color(0xfff0fdf4);
  static const Color successDark = Color(0xff166534);
  static const Color warning = Color(0xff854d0e);
  static const Color lightWarning = Color(0xfffed7aa);
  static const Color lightOrange = Color(0xfff3e8ff);
  static const Color lightPink = Color(0xfff3e8ff);
  static const Color lightPink1 = Color(0xfff3e8ff);
  static const Color light1 = Color(0xffeff6ff);
  static const Color lightBlue = Color(0xffe5e7eb);
}
