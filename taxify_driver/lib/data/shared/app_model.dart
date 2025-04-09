// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AppModel {
  final ThemeMode? themeMode;

  AppModel({this.themeMode});

  AppModel copyWith({ThemeMode? themeMode}) {
    return AppModel(themeMode: themeMode ?? this.themeMode);
  }
}
