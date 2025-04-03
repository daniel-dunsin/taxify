import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class SignUpStep4 extends StatelessWidget {
  const SignUpStep4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add Vehicle", style: getTextTheme(context).headlineLarge),
        SizedBox(height: 8),
        Text(
          "Add your first vehicle.",
          style: getTextTheme(
            context,
          ).bodyLarge?.copyWith(color: AppColors.lightGray),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
