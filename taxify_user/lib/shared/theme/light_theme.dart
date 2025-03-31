import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/theme/default_theme.dart';

final lightTheme = defaultTheme.copyWith(
  appBarTheme: defaultTheme.appBarTheme.copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    foregroundColor: AppColors.dark,
    titleTextStyle: defaultTheme.appBarTheme.titleTextStyle?.copyWith(
      color: AppColors.dark,
    ),
    iconTheme: defaultTheme.appBarTheme.iconTheme?.copyWith(
      color: AppColors.dark,
    ),
    actionsIconTheme: defaultTheme.appBarTheme.actionsIconTheme?.copyWith(
      color: AppColors.dark,
    ),
  ),
  iconTheme: IconThemeData(color: AppColors.light),
  scaffoldBackgroundColor: AppColors.light,
  dialogTheme: defaultTheme.dialogTheme.copyWith(
    barrierColor: Color.fromRGBO(0, 0, 0, 0.4),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.light,
    onPrimary: AppColors.dark,
    secondary: Colors.grey[300]!,
    onSecondary: Colors.black54,
    surface: AppColors.accent,
    onSurface: AppColors.dark,
    error: AppColors.error,
    onError: AppColors.light,
  ),
  dividerColor: Colors.grey[300]!,
  indicatorColor: AppColors.accent,
  splashColor: AppColors.accent.withAlpha(150),
  hintColor: Colors.grey[300]!,
  textTheme: TextTheme(
    displayLarge: defaultTheme.textTheme.displayLarge?.copyWith(
      color: AppColors.dark,
    ),
    displayMedium: defaultTheme.textTheme.displayMedium?.copyWith(
      color: AppColors.dark,
    ),
    displaySmall: defaultTheme.textTheme.displaySmall?.copyWith(
      color: AppColors.dark,
    ),
    headlineLarge: defaultTheme.textTheme.headlineLarge?.copyWith(
      color: AppColors.dark,
    ),
    headlineMedium: defaultTheme.textTheme.headlineMedium?.copyWith(
      color: AppColors.dark,
    ),
    headlineSmall: defaultTheme.textTheme.headlineSmall?.copyWith(
      color: AppColors.dark,
    ),
    titleLarge: defaultTheme.textTheme.titleLarge?.copyWith(
      color: AppColors.dark,
    ),
    titleMedium: defaultTheme.textTheme.titleMedium?.copyWith(
      color: AppColors.dark,
    ),
    titleSmall: defaultTheme.textTheme.titleSmall?.copyWith(
      color: AppColors.dark,
    ),
    bodyLarge: defaultTheme.textTheme.bodyLarge?.copyWith(
      color: AppColors.dark,
    ),
    bodyMedium: defaultTheme.textTheme.bodyMedium?.copyWith(
      color: AppColors.dark,
    ),
    bodySmall: defaultTheme.textTheme.bodySmall?.copyWith(
      color: AppColors.dark,
    ),
    labelLarge: defaultTheme.textTheme.labelLarge?.copyWith(
      color: AppColors.dark,
    ),
    labelMedium: defaultTheme.textTheme.labelMedium?.copyWith(
      color: AppColors.dark,
    ),
    labelSmall: defaultTheme.textTheme.labelSmall?.copyWith(
      color: AppColors.dark,
    ),
  ),
  bottomNavigationBarTheme: defaultTheme.bottomNavigationBarTheme.copyWith(
    selectedLabelStyle: defaultTheme.bottomNavigationBarTheme.selectedLabelStyle
        ?.copyWith(color: AppColors.accent),
    unselectedLabelStyle: defaultTheme
        .bottomNavigationBarTheme
        .unselectedLabelStyle
        ?.copyWith(color: Colors.black54),
    selectedIconTheme: IconThemeData(color: AppColors.accent),
    unselectedIconTheme: IconThemeData(color: Colors.black54),
    backgroundColor: AppColors.light,
    selectedItemColor: AppColors.accent,
    unselectedItemColor: Colors.black54,
  ),
);
