import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc.dart';
import 'package:taxify_driver/presentation/auth/pages/otp_verification.dart';
import 'package:taxify_driver/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/utils/validators.dart';
import 'package:taxify_driver/shared/widgets/back_button.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/logo.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submit() {
    if (_formKey.currentState?.validate() != true) return;

    getIt.get<AuthBloc>().add(
      RequestLoginOtpRequested(phoneNumber: phoneNumberController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton(), title: Logo()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppStyles.defaultPagePadding.copyWith(top: 20),
          child: BlocListener(
            bloc: getIt.get<AuthBloc>(),
            listener: (context, state) {
              if (state is RequestLoginLoading) {
                DialogLoader().show(context);
              } else {
                DialogLoader().hide();
                if (state is RequestLoginSuccess) {
                  if (state.isVerified) {
                    NetworkToast.handleSuccess("Enter your otp to log in");
                    GoRouter.of(context).pushNamed(
                      AuthRoutes.otpVerification,
                      extra: {
                        "reason": OtpReason.login,
                        "email": phoneNumberController.text,
                      },
                    );
                  } else {
                    NetworkToast.handleError(
                      "Account not verified, verifiy before proceeding",
                    );
                    GoRouter.of(context).pushNamed(
                      AuthRoutes.otpVerification,
                      extra: {"reason": OtpReason.signUp, "email": state.email},
                    );
                  }
                }
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 50, child: Divider()),
                  SizedBox(height: 10),
                  Text(
                    "Welcome back!",
                    style: getTextTheme(context).headlineLarge,
                  ),
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
                    controller: phoneNumberController,
                    validator: (value) => AppValidators.phoneNumber(value),
                  ),
                  SizedBox(height: 40),
                  ContainedButton(
                    onPressed: submit,
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
        ),
      ),
    );
  }
}
