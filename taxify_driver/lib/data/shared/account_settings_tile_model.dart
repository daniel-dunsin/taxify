// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class AccountSettingsTileModel {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onClick;

  AccountSettingsTileModel({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onClick,
  });
}
