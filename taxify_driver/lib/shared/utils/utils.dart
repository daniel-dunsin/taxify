import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

ColorScheme getColorSchema(BuildContext context) {
  return Theme.of(context).colorScheme;
}

bool checkLightMode(BuildContext context) {
  return getColorSchema(context).brightness == Brightness.light;
}

TextTheme getTextTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

Future<bool> grantPermission(Permission permission) async {
  if (await permission.isGranted ||
      await permission.isLimited ||
      await permission.isProvisional) {
    return true;
  }

  PermissionStatus permissionStatus = await permission.request();

  if (permissionStatus.isGranted ||
      permissionStatus.isLimited ||
      permissionStatus.isProvisional) {
    return true;
  }

  return false;
}

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
