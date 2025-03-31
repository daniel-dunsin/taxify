import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/auth/sign_up_model.dart';
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

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onSubmit() {
    if (_formKey.currentState?.validate() == true) {
      getIt.get<AuthBloc>().add(
        SignUpRequested(
          SignUpModel(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
            phoneNumber: phoneNumberController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton(), title: Logo()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppStyles.defaultPagePadding.copyWith(top: 20),
          child: BlocConsumer(
            bloc: getIt.get<AuthBloc>(),
            listener: (context, state) {
              if (state is SignUpLoading) {
                DialogLoader().show(context);
              } else {
                DialogLoader().hide();
                if (state is SignUpSuccess) {
                  NetworkToast.handleSuccess(
                    "Signed up successfully, verify your account",
                  );
                  GoRouter.of(context).pushNamed(
                    AuthRoutes.otpVerification,
                    extra: {
                      "email": emailController.text,
                      "reason": OtpReason.signUp,
                    },
                  );
                }
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 50, child: Divider()),
                    SizedBox(height: 10),
                    Text(
                      "Create your account",
                      style: getTextTheme(context).headlineLarge,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Explore your life by journeying with Taxify.",
                      style: getTextTheme(
                        context,
                      ).bodyLarge?.copyWith(color: AppColors.lightGray),
                    ),
                    SizedBox(height: 20),
                    AppTextInput(
                      labelText: "First Name",
                      hintText: "Enter first name",
                      controller: firstNameController,
                      validator:
                          (value) => AppValidators.defaultValidator(value),
                    ),
                    SizedBox(height: 10),
                    AppTextInput(
                      labelText: "Last Name",
                      hintText: "Enter last name",
                      controller: lastNameController,
                      validator:
                          (value) => AppValidators.defaultValidator(value),
                    ),
                    SizedBox(height: 10),
                    AppTextInput(
                      labelText: "Email",
                      hintText: "Enter email",
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      validator: (value) => AppValidators.email(value),
                    ),
                    SizedBox(height: 10),
                    AppTextInput(
                      labelText: "Phone number",
                      hintText: "Enter phone number",
                      keyboardType: TextInputType.phone,
                      controller: phoneNumberController,
                      validator: (value) => AppValidators.phoneNumber(value),
                    ),
                    SizedBox(height: 40),
                    ContainedButton(
                      onPressed: onSubmit,
                      width: double.maxFinite,
                      child: Text("Sign Up"),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account?",
                              style: getTextTheme(context).bodyMedium,
                            ),
                            TextSpan(
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap =
                                        () => GoRouter.of(
                                          context,
                                        ).pushNamed(AuthRoutes.signIn),
                              text: " Sign in",
                              style: getTextTheme(context).bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
