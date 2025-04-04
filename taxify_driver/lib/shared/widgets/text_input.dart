// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

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
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final TextInputType? keyboardType;
  final bool disabled;
  final bool loading;

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
    this.controller,
    this.validator,
    this.keyboardType,
    this.disabled = false,
    this.loading = false,
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
              SizedBox(height: 10),
            ]),
        TextFormField(
          validator: validator,
          controller: controller,
          cursorColor:
              getColorSchema(context).brightness == Brightness.light
                  ? AppColors.dark
                  : AppColors.accent,
          showCursor: true,
          keyboardType: keyboardType,
          style: TextStyle(fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            enabled: !disabled && !loading,
            hintText: hintText,
            hintStyle: getTextTheme(context).labelSmall?.copyWith(fontSize: 15),
            suffixIcon: suffixIcon,
            suffixIconColor:
                sufficIconColor ?? getColorSchema(context).onPrimary,
            icon: icon,
            iconColor: iconColor,
            prefixIcon: prefixIcon,
            prefixIconColor: prefixIconColor,
            filled: true,
            fillColor:
                checkLightMode(context)
                    ? getColorSchema(context).primary
                    : AppColors.darkGray,
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.transparent),
              borderRadius: BorderRadius.circular(6),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: Colors.transparent),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1.5,
                color:
                    getColorSchema(context).brightness == Brightness.light
                        ? AppColors.dark
                        : AppColors.accent,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.error),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.5, color: AppColors.error),
              borderRadius: BorderRadius.circular(6),
            ),
            errorStyle: TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
