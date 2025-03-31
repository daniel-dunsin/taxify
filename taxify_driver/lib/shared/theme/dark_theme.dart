import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/theme/default_theme.dart';

final darkTheme = defaultTheme.copyWith(
  appBarTheme: defaultTheme.appBarTheme.copyWith(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    foregroundColor: AppColors.light,
    titleTextStyle: defaultTheme.appBarTheme.titleTextStyle?.copyWith(
      color: AppColors.light,
    ),
    iconTheme: defaultTheme.appBarTheme.iconTheme?.copyWith(
      color: AppColors.light,
    ),
    actionsIconTheme: defaultTheme.appBarTheme.actionsIconTheme?.copyWith(
      color: AppColors.light,
    ),
  ),
  iconTheme: IconThemeData(color: AppColors.light),
  scaffoldBackgroundColor: AppColors.dark,
  dialogTheme: defaultTheme.dialogTheme.copyWith(
    barrierColor: Color.fromRGBO(93, 93, 93, 0.4),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.dark,
    onPrimary: AppColors.light,
    secondary: AppColors.darkGray,
    onSecondary: Colors.grey[200]!,
    surface: AppColors.accent,
    onSurface: AppColors.light,
    error: AppColors.error,
    onError: AppColors.light,
  ),
  dividerColor: Colors.black54,
  indicatorColor: AppColors.dark,
  splashColor: AppColors.accent.withAlpha(150),
  hintColor: Colors.grey[300]!,
  textTheme: TextTheme(
    displayLarge: defaultTheme.textTheme.displayLarge?.copyWith(
      color: AppColors.light,
    ),
    displayMedium: defaultTheme.textTheme.displayMedium?.copyWith(
      color: AppColors.light,
    ),
    displaySmall: defaultTheme.textTheme.displaySmall?.copyWith(
      color: AppColors.light,
    ),
    headlineLarge: defaultTheme.textTheme.headlineLarge?.copyWith(
      color: AppColors.light,
    ),
    headlineMedium: defaultTheme.textTheme.headlineMedium?.copyWith(
      color: AppColors.light,
    ),
    headlineSmall: defaultTheme.textTheme.headlineSmall?.copyWith(
      color: AppColors.light,
    ),
    titleLarge: defaultTheme.textTheme.titleLarge?.copyWith(
      color: AppColors.light,
    ),
    titleMedium: defaultTheme.textTheme.titleMedium?.copyWith(
      color: AppColors.light,
    ),
    titleSmall: defaultTheme.textTheme.titleSmall?.copyWith(
      color: AppColors.light,
    ),
    bodyLarge: defaultTheme.textTheme.bodyLarge?.copyWith(
      color: AppColors.light,
    ),
    bodyMedium: defaultTheme.textTheme.bodyMedium?.copyWith(
      color: AppColors.light,
    ),
    bodySmall: defaultTheme.textTheme.bodySmall?.copyWith(
      color: AppColors.light,
    ),
    labelLarge: defaultTheme.textTheme.labelLarge?.copyWith(
      color: AppColors.light,
    ),
    labelMedium: defaultTheme.textTheme.labelMedium?.copyWith(
      color: AppColors.light,
    ),
    labelSmall: defaultTheme.textTheme.labelSmall?.copyWith(
      color: AppColors.light,
    ),
  ),
  bottomNavigationBarTheme: defaultTheme.bottomNavigationBarTheme.copyWith(
    selectedLabelStyle: defaultTheme.bottomNavigationBarTheme.selectedLabelStyle
        ?.copyWith(color: AppColors.dark),
    unselectedLabelStyle: defaultTheme
        .bottomNavigationBarTheme
        .unselectedLabelStyle
        ?.copyWith(color: AppColors.light),
    selectedIconTheme: IconThemeData(color: AppColors.dark),
    unselectedIconTheme: IconThemeData(color: AppColors.light),
    backgroundColor: AppColors.dark,
    selectedItemColor: AppColors.dark,
    unselectedItemColor: AppColors.light,
  ),
);
