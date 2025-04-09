import 'dart:io';

import 'package:flutter/material.dart';

class AppColors {
  static const Color accent = Color.fromARGB(255, 222, 211, 2);
  static const Color light = Color(0XFFFFFFFF);
  static const Color dark = Color(0XFF1C1C1C);
  static const Color darkGray = Color.fromARGB(255, 59, 59, 59);
  static const Color lightGray = Color.fromARGB(232, 152, 152, 152);
  static const Color error = Color(0XFFE53935);
  static const Color success = Color.fromARGB(255, 1, 204, 25);
  static const Color info = Color.fromARGB(255, 1, 96, 204);
}

class AppFonts {
  static const String plusJakarta = "PlusJakarta";
}

class AppConstants {
  static String get serverBaseUrl {
    return Platform.isAndroid
        ? "http://10.0.2.2:3001/api/v1"
        : "http://localhost:3001/api/v1";
  }

  static const nhtsaServerBaseUrl = "https://vpic.nhtsa.dot.gov/api/vehicles";
}

class AppStorageConstants {
  static String accessToken = "accessToken";
  static String themeMode = "themeMode";
}

class AppStyles {
  static const defaultPagePadding = EdgeInsets.symmetric(
    vertical: 20,
    horizontal: 20,
  );
  static Color shimmerBaseColor = Color.fromRGBO(129, 129, 129, 0.498);
  static Color shipmmerHighlightColor = Color.fromRGBO(164, 164, 164, 1);
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

const appVehicleRules = <String>[
  "Max, 2 in the back",
  "No food consumption in car",
  "No smoking/drinking in the car",
  "Seatbelts must be worn at all times",
  "No loud music or phone calls",
  "Treat the vehicle with respect",
  "Keep feet off the seats",
  "Children must be accompanied by an adult",
];
