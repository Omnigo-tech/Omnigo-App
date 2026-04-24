import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import '../colors_resources.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.white,
      
      // Global Poppins font
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: DimensionsResources.D_32,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: DimensionsResources.D_20,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: DimensionsResources.D_16,
          color: AppColors.black,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: DimensionsResources.D_14,
          color: AppColors.black,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: DimensionsResources.D_14,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),

      appBarTheme:  AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: DimensionsResources.D_0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.black),
        titleTextStyle: GoogleFonts.poppins(
          color: AppColors.black,
          fontSize: DimensionsResources.D_18.w,
          fontWeight: FontWeight.w600,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
          ),
          textStyle:  TextStyle(
            fontSize: DimensionsResources.D_16.w,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.itemBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        labelStyle: const TextStyle(color: AppColors.grey),
        hintStyle: const TextStyle(color: AppColors.grey),
      ),
    );
  }
}
