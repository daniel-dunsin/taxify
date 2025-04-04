// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class AppTextInputDecorator extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? value;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Color? sufficIconColor;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final Widget? icon;
  final Color? iconColor;
  final bool disabled;
  final bool loading;
  final VoidCallback? onClick;
  final VoidCallback? onCancel;

  const AppTextInputDecorator({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
    this.hintStyle,
    this.suffixIcon,
    this.sufficIconColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.icon,
    this.iconColor,
    this.onClick,
    this.onCancel,
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
        GestureDetector(
          onTap:
              disabled
                  ? null
                  : () {
                    if (value == null) {
                      onClick?.call();
                    }
                  },
          child: InputDecorator(
            decoration: InputDecoration(
              enabled: !disabled && !loading,
              suffixIcon: GestureDetector(
                onTap:
                    disabled
                        ? null
                        : () {
                          if (value != null) {
                            onCancel?.call();
                          } else {
                            onClick?.call();
                          }
                        },
                child: Icon(
                  value == null || disabled ? Icons.chevron_right : Icons.close,
                  color: getColorSchema(context).onPrimary,
                ),
              ),

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
            child: Row(
              children: [
                Text(
                  loading ? "Loading..." : value ?? hintText ?? "",
                  style:
                      hintStyle ??
                      getTextTheme(context).labelSmall?.copyWith(fontSize: 15),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
