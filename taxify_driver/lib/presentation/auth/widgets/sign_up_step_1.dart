import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/utils/validators.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class SignUpStep1 extends StatefulWidget {
  const SignUpStep1({super.key});

  @override
  State<SignUpStep1> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final data = getIt.get<SignUpStepsBloc>().state.signUpModel;

    emailController = TextEditingController(text: data.email);
    firstNameController = TextEditingController(text: data.firstName);
    lastNameController = TextEditingController(text: data.lastName);
    phoneNumberController = TextEditingController(text: data.phoneNumber);
  }

  void onSubmit() {
    if (_formKey.currentState?.validate() == true) {
      getIt.get<SignUpStepsBloc>().add(
        UpdateSignUpStepsData(
          getIt.get<SignUpStepsBloc>().state.signUpModel.copyWith(
            email: emailController.text,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            phoneNumber: phoneNumberController.text,
          ),
        ),
      );

      getIt.get<SignUpStepsBloc>().add(IncreaseSignUpSteps());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            validator: (value) => AppValidators.defaultValidator(value),
          ),
          SizedBox(height: 10),
          AppTextInput(
            labelText: "Last Name",
            hintText: "Enter last name",
            controller: lastNameController,
            validator: (value) => AppValidators.defaultValidator(value),
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
  }
}
