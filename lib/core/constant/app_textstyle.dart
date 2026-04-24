import 'package:flutter/material.dart';
import 'package:hells360/core/constant/app_colors.dart';

class AppFonts {
  static const String monaSans = "mona-sans";
  static const String georgia  = 'Georgia'; 

}

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle appBarTitle = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 20,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.georgia,
    fontSize  : 32,
    color     : AppColors.primary,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.georgia,
    fontSize  : 26,
    color     : AppColors.primary,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppFonts.georgia,
    fontSize  : 22,
    color     : AppColors.primary,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  static const TextStyle black24bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 24,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle black20bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 20,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle black18bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 18,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle black16bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle black16semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle black14bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle black14semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle black14normal = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle black12semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 12,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle black12normal = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 12,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle black10normal = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 10,
    color     : AppColors.textPrimary,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle grey18 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 18,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle grey16 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle grey16semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle grey14 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle grey14semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle grey13 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 13,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w400,
    height   : 1.5,
  );

  static const TextStyle grey12 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 12,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle grey11 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 11,
    color     : AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle hint13 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 13,
    color     : AppColors.textHint,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle hint12 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 12,
    color     : AppColors.textHint,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle hint11 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 11,
    color     : AppColors.textHint,
    fontWeight: FontWeight.w400,
    height   : 1.5,
  );

  static const TextStyle primary18bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 18,
    color     : AppColors.primary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle primary16bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : AppColors.primary,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle primary16semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle primary14semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle primary13semibold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 13,
    color     : AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle white20bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 20,
    color     : Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle white16bold = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 16,
    color     : Colors.white,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static const TextStyle white14 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : Colors.white,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle white12italic = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 12,
    color     : Color(0xCCFFFFFF),
    fontWeight: FontWeight.w400,
    fontStyle : FontStyle.italic,
    letterSpacing: 0.2,
  );

  static const TextStyle success14 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.success,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle error14 = TextStyle(
    fontFamily: AppFonts.monaSans,
    fontSize  : 14,
    color     : AppColors.error,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle label12 = TextStyle(
    fontFamily  : AppFonts.monaSans,
    fontSize    : 12.5,
    color       : AppColors.textPrimary,
    fontWeight  : FontWeight.w600,
    letterSpacing: 0.3,
  );
}