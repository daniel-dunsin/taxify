import 'package:flutter/material.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final defaultTheme = ThemeData(
  useMaterial3: true,
  fontFamily: AppFonts.plusJakarta,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(width: 1.5, color: Colors.transparent),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(width: 1.5, color: AppColors.error),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(width: 1.5, color: AppColors.darkGray),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(width: 1.5, color: Colors.transparent),
    ),
    hintStyle: TextStyle(fontSize: 16),
    errorStyle: TextStyle(color: AppColors.error),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(fontSize: 18.sp),
    iconTheme: IconThemeData(size: 20),
    actionsIconTheme: IconThemeData(size: 20),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
    elevation: 3,
    backgroundColor: AppColors.accent,
    foregroundColor: AppColors.darkGray,
  ),
  primaryColor: AppColors.light,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 42.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      fontSize: 42.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      fontSize: 42.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w300,
    ),
    headlineLarge: TextStyle(
      fontSize: 30.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontSize: 30.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      fontSize: 30.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w300,
    ),
    titleLarge: TextStyle(
      fontSize: 18.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      fontSize: 18.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w400,
    ),
    titleSmall: TextStyle(
      fontSize: 18.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w300,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 16.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w300,
    ),
    labelLarge: TextStyle(
      fontSize: 14.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.bold,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      fontSize: 14.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w300,
    ),
  ),
  disabledColor: Colors.grey[500],
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    alignment: Alignment.centerLeft,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: TextStyle(
      fontSize: 16.sp,
      fontFamily: AppFonts.plusJakarta,
      color: AppColors.dark,
      fontWeight: FontWeight.w400,
    ),
  ),
  listTileTheme: ListTileThemeData(
    minTileHeight: 30,
    minVerticalPadding: 0,
    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedLabelStyle: TextStyle(fontSize: 13.h),
    unselectedLabelStyle: TextStyle(fontSize: 13.h),
    showUnselectedLabels: true,
    showSelectedLabels: true,
  ),
);
