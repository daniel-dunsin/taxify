import 'package:flutter/material.dart';

class AppColors {
  static const Color accent = Color.fromARGB(255, 222, 211, 2);
  static const Color light = Color(0XFFFFFFFF);
  static const Color dark = Color(0XFF1C1C1C);
  static const Color darkGray = Color(0XFF555555);
  static const Color lightGray = Color.fromARGB(232, 152, 152, 152);
  static const Color error = Color(0XFFE53935);
  static const Color success = Color.fromARGB(255, 1, 204, 25);
}

class AppFonts {
  static const String plusJakarta = "PlusJakarta";
}

class AppConstants {
  static const serverBaseUrl = "http://localhost:3001/api/v1";
}

class AppStorageConstants {
  static String accessToken = "accessToken";
}

class AppStyles {
  static const defaultPagePadding = EdgeInsets.symmetric(
    vertical: 20,
    horizontal: 16,
  );
}
