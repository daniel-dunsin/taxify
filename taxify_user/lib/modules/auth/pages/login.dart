import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/modules/auth/routes/auth_routes.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/back_button.dart';
import 'package:taxify_user/shared/widgets/button.dart';
import 'package:taxify_user/shared/widgets/logo.dart';
import 'package:taxify_user/shared/widgets/text_input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton(), title: Logo()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppStyles.defaultPagePadding.copyWith(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 50, child: Divider()),
              SizedBox(height: 10),
              Text("Welcome back!", style: getTextTheme(context).headlineLarge),
              SizedBox(height: 8),
              Text(
                "Login to continue your journey.",
                style: getTextTheme(
                  context,
                ).bodyLarge?.copyWith(color: AppColors.lightGray),
              ),
              SizedBox(height: 20),
              AppTextInput(
                labelText: "Phone number",
                hintText: "Enter phone number",
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 40),
              ContainedButton(
                onPressed: () {},
                width: double.maxFinite,
                child: Text("Get OTP"),
              ),
              SizedBox(height: 20),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account",
                        style: getTextTheme(context).bodyMedium,
                      ),
                      TextSpan(
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap =
                                  () => GoRouter.of(
                                    context,
                                  ).pushNamed(AuthRoutes.signUp),
                        text: " Sign up",
                        style: getTextTheme(context).bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
