import 'package:elgassos/core/ui/app_colors.dart';
import 'package:elgassos/core/ui/app_styles_fonts.dart';
import 'package:flutter/material.dart';

extension FontExtensions on BuildContext {
  TextStyle textStyle({
    double size = 14,
    FontWeight weight = FontWeight.w500,
    Color color = AppColors.primaryTextColor,
    double letterSpacing = 0,
    String fontFamily = AppFonts.primaryFont, // Default to primary
  }) {
    return AppFonts.style(
      context: this,
      size: size,
      weight: weight,
      color: color,
      fontFamily: fontFamily,
      letterSpacing: letterSpacing,
    );
  }

  // Existing styles
  TextStyle get caption => textStyle(
        size: AppFonts.sizes.s14,
        weight: AppFonts.weights.normal,
      );

  TextStyle get hintText => textStyle(
        size: AppFonts.sizes.s14,
        weight: AppFonts.weights.normal,
        color: AppColors.hintColor,
      );

  TextStyle get headingLarge => textStyle(
        size: AppFonts.sizes.s36,
        weight: AppFonts.weights.bold,
        letterSpacing: 1.3,
      );

  TextStyle get bodyLarge => textStyle(
        size: AppFonts.sizes.s18,
        weight: AppFonts.weights.normal,
        letterSpacing: 1.3,
        fontFamily: AppFonts.primaryFont,
      );

  TextStyle get bodyMedium => textStyle(
        size: AppFonts.sizes.s16,
        weight: AppFonts.weights.normal,
        letterSpacing: 1.3,
        fontFamily: AppFonts.secondaryFont,
      );
  TextStyle get title => textStyle(
        size: AppFonts.sizes.s24,
        weight: AppFonts.weights.bold,
        letterSpacing: 1.3,
        fontFamily: AppFonts.secondaryFont,
      );

  TextStyle get errorText => textStyle(
        size: AppFonts.sizes.s14,
        weight: AppFonts.weights.normal,
        color: Colors.red,
      );
}
