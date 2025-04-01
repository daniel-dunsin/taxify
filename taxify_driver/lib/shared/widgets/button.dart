// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class ContainedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Widget? icon;
  final IconAlignment? iconAlignment;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? iconColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool disabled;

  const ContainedButton({
    super.key,
    this.width,
    this.height,
    this.icon,
    this.iconAlignment,
    this.backgroundColor,
    this.foregroundColor,
    this.iconColor,
    this.splashFactory,
    this.borderRadius,
    this.padding,
    required this.onPressed,
    required this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: disabled == true ? null : onPressed,
      label: child,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            backgroundColor ??
            (checkLightMode(context)
                ? getColorSchema(context).onPrimary
                : AppColors.accent),
        minimumSize: Size(120, 40),
        fixedSize: Size(width ?? 200, height ?? 50),
        foregroundColor: foregroundColor ?? getColorSchema(context).primary,
        disabledBackgroundColor: AppColors.lightGray,
        disabledForegroundColor: AppColors.darkGray,
        iconColor: iconColor ?? getColorSchema(context).primary,
        side: BorderSide.none,
        splashFactory: splashFactory ?? InkSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
        padding: padding ?? EdgeInsets.all(10),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      icon: icon,
      iconAlignment: iconAlignment,
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final Widget? icon;
  final IconAlignment? iconAlignment;
  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? iconColor;
  final InteractiveInkFeatureFactory? splashFactory;
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool disabled;
  final double? borderWidth;
  final Color? borderColor;

  const AppOutlinedButton({
    super.key,
    this.width,
    this.height,
    this.icon,
    this.iconAlignment,
    this.foregroundColor,
    this.iconColor,
    this.splashFactory,
    this.borderRadius,
    this.padding,
    this.borderWidth,
    this.borderColor,
    required this.onPressed,
    required this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: disabled == true ? null : onPressed,
      label: child,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(120, 40),
        fixedSize: Size(width ?? 200, height ?? 50),
        foregroundColor: foregroundColor ?? getColorSchema(context).onPrimary,
        disabledBackgroundColor: AppColors.lightGray,
        disabledForegroundColor: AppColors.darkGray,
        iconColor: iconColor ?? getColorSchema(context).primary,
        side: BorderSide(
          width: borderWidth ?? 1.5,
          color: borderColor ?? getColorSchema(context).onPrimary,
        ),
        splashFactory: splashFactory ?? InkSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 4),
        ),
        padding: padding ?? EdgeInsets.all(10),
        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      icon: icon,
      iconAlignment: iconAlignment,
    );
  }
}
