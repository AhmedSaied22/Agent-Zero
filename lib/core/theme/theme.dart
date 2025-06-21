import 'package:elgassos/core/ui/app_colors.dart';
import 'package:elgassos/core/ui/app_styles_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final baseTextStyle = const TextStyle(
      fontFamily: AppFonts.primaryFont,
      color: AppColors.primaryTextColor,
    );

    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        bodyLarge: baseTextStyle.copyWith(fontSize: AppFonts.sizes.s20),
        bodyMedium: baseTextStyle.copyWith(fontSize: AppFonts.sizes.s16),
        displayLarge: baseTextStyle.copyWith(fontSize: AppFonts.sizes.s32),
        displayMedium: baseTextStyle.copyWith(fontSize: AppFonts.sizes.s28),
        displaySmall: baseTextStyle.copyWith(fontSize: AppFonts.sizes.s24),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: baseTextStyle.copyWith(fontSize: 24.sp),
      ),
    );
  }
}
