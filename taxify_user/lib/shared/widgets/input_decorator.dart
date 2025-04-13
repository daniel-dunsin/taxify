// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/utils/utils.dart';

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
  final Color? fillColor;
  final bool disabled;
  final bool loading;
  final VoidCallback? onClick;
  final VoidCallback? onCancel;
  final EdgeInsets? contentPadding;
  final double? labelVerticalGap;

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
    this.fillColor,
    this.onClick,
    this.onCancel,
    this.contentPadding,
    this.labelVerticalGap,
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
              SizedBox(height: labelVerticalGap ?? 10),
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
              contentPadding: contentPadding,
              enabled: !disabled && !loading,
              suffixIcon:
                  suffixIcon ??
                  GestureDetector(
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
                      value == null || disabled
                          ? Icons.chevron_right
                          : Icons.close,
                      color: getColorSchema(context).onPrimary,
                    ),
                  ),

              suffixIconColor:
                  sufficIconColor ?? getColorSchema(context).onPrimary,
              icon: icon,
              iconColor: iconColor,
              prefixIcon:
                  prefixIcon != null
                      ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 6,
                        ),
                        child: prefixIcon,
                      )
                      : null,
              prefixIconColor: prefixIconColor,
              filled: true,
              fillColor:
                  fillColor ??
                  (checkLightMode(context)
                      ? getColorSchema(context).primary
                      : AppColors.darkGray),
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
                Expanded(
                  child: Text(
                    loading ? "Loading..." : value ?? hintText ?? "",
                    style:
                        hintStyle ??
                        getTextTheme(
                          context,
                        ).labelSmall?.copyWith(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
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
