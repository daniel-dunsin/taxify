// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/utils/utils.dart';

class AppTextInput extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Color? sufficIconColor;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Widget? icon;
  final Color? iconColor;
  final Color? fillColor;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final TextInputType? keyboardType;
  final int? maxLength;
  final EdgeInsets? contentPadding;
  final bool disabled;
  final bool loading;
  final bool underline;
  final double? labelVerticalGap;

  const AppTextInput({
    super.key,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    this.sufficIconColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.icon,
    this.iconColor,
    this.fillColor,
    this.controller,
    this.validator,
    this.keyboardType,
    this.maxLength,
    this.contentPadding,
    this.labelVerticalGap,
    this.disabled = false,
    this.loading = false,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...(labelText == null
            ? []
            : [
              Text(
                labelText!,
                style: getTextTheme(
                  context,
                ).bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: labelVerticalGap ?? 10),
            ]),
        TextFormField(
          validator: validator,
          controller: controller,
          cursorColor:
              underline
                  ? getColorSchema(context).onPrimary
                  : (getColorSchema(context).brightness == Brightness.light
                      ? AppColors.dark
                      : AppColors.accent),
          showCursor: true,
          keyboardType: keyboardType,
          style: TextStyle(fontWeight: FontWeight.w500),
          maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
          maxLength: maxLength,
          buildCounter: (
            context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) {
            return null;
          },
          decoration: getInputDecorator(context),
        ),
      ],
    );
  }

  InputDecoration getInputDecorator(BuildContext context) {
    return InputDecoration(
      contentPadding: contentPadding,
      enabled: !disabled && !loading,
      hintText: hintText,
      hintStyle: getTextTheme(context).labelSmall?.copyWith(fontSize: 15),
      suffixIcon: suffixIcon,
      suffixIconColor: sufficIconColor ?? getColorSchema(context).onPrimary,
      icon: icon,
      iconColor: iconColor,
      prefixIcon: prefixIcon,
      prefixIconColor: prefixIconColor,
      filled: true,
      fillColor:
          fillColor ??
          (checkLightMode(context)
              ? getColorSchema(context).primary
              : AppColors.darkGray),
      border:
          underline
              ? UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.transparent),
                borderRadius: BorderRadius.circular(0),
              )
              : OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.transparent),
                borderRadius: BorderRadius.circular(6),
              ),
      enabledBorder:
          underline
              ? UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.transparent),
                borderRadius: BorderRadius.circular(0),
              )
              : OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.transparent),
                borderRadius: BorderRadius.circular(6),
              ),
      focusedBorder:
          underline
              ? UnderlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color: getColorSchema(context).onPrimary,
                ),
                borderRadius: BorderRadius.circular(0),
              )
              : OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.5,
                  color:
                      getColorSchema(context).brightness == Brightness.light
                          ? AppColors.dark
                          : AppColors.accent,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
      errorBorder:
          underline
              ? UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.error),
                borderRadius: BorderRadius.circular(0),
              )
              : OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.error),
                borderRadius: BorderRadius.circular(6),
              ),
      focusedErrorBorder:
          underline
              ? UnderlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.error),
                borderRadius: BorderRadius.circular(0),
              )
              : OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: AppColors.error),
                borderRadius: BorderRadius.circular(6),
              ),
      errorStyle: TextStyle(color: AppColors.error, fontSize: 12),
    );
  }
}
