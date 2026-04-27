import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get headingLarge => GoogleFonts.tajawal(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingMedium => GoogleFonts.tajawal(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle get headingSmall => GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.ibmPlexSansArabic(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.ibmPlexSansArabic(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.ibmPlexSansArabic(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get button => GoogleFonts.ibmPlexSansArabic(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  static TextStyle get caption => GoogleFonts.ibmPlexSansArabic(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textLight,
      );
}
