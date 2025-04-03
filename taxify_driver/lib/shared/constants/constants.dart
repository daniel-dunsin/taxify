import 'package:flutter/material.dart';

class AppColors {
  static const Color accent = Color.fromARGB(255, 222, 211, 2);
  static const Color light = Color(0XFFFFFFFF);
  static const Color dark = Color(0XFF1C1C1C);
  static const Color darkGray = Color.fromARGB(255, 59, 59, 59);
  static const Color lightGray = Color.fromARGB(232, 152, 152, 152);
  static const Color error = Color(0XFFE53935);
  static const Color success = Color.fromARGB(255, 1, 204, 25);
}

class AppFonts {
  static const String plusJakarta = "PlusJakarta";
}

class AppConstants {
  static const serverBaseUrl = "http://localhost:3001/api/v1";
  static const nhtsaServerBaseUrl = "https://vpic.nhtsa.dot.gov/api/vehicles";
}

class AppStorageConstants {
  static String accessToken = "accessToken";
}

class AppStyles {
  static const defaultPagePadding = EdgeInsets.symmetric(
    vertical: 20,
    horizontal: 24,
  );
}

class AppMatchers {
  static RegExp email = RegExp(
    r"^[a-z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );

  static RegExp base64 = RegExp(r"/data:([a-zA-Z0-9]+\/[a-zA-Z0-9-.+]+)/");

  static RegExp phoneNumber = RegExp(
    r"^\+?[0-9]{1,4}?[-.\s]?\(?[0-9]{1,4}\)?[-.\s]?[0-9\s.-]{4,14}$",
  );

  static RegExp password = RegExp(
    r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>])(?=.{8,}).*$',
  );
}
