import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/auth/verify_otp_model.dart';
import 'package:taxify_user/presentation/auth/blocs/auth_bloc.dart';
import 'package:taxify_user/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/network/network_toast.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/utils/validators.dart';
import 'package:taxify_user/shared/widgets/back_button.dart';
import 'package:taxify_user/shared/widgets/button.dart';
import 'package:taxify_user/shared/widgets/dialog_loader.dart';
import 'package:taxify_user/shared/widgets/logo.dart';
import 'package:taxify_user/shared/widgets/text_input.dart';

enum OtpReason { login, signUp }

class OtpVerificationPage extends StatefulWidget {
  final OtpReason otpReason;
  final String email;
  const OtpVerificationPage({
    super.key,
    required this.otpReason,
    required this.email,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submit() {
    if (_formKey.currentState?.validate() != true) return;

    getIt.get<AuthBloc>().add(
      widget.otpReason == OtpReason.login
          ? VerifyLoginOtpRequested(
            VerifyOtpModel(phoneNumber: widget.email, otp: otpController.text),
          )
          : VerifySignUpOtpRequested(
            VerifyOtpModel(email: widget.email, otp: otpController.text),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.otpReason == OtpReason.login ? AppBackButton() : null,
        title: Logo(),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppStyles.defaultPagePadding.copyWith(top: 20),
          child: BlocListener<AuthBloc, AuthState>(
            bloc: getIt.get<AuthBloc>(),
            listener: (context, state) {
              if (state is VerifyOtpLoading) {
                DialogLoader().show(context);
              } else {
                DialogLoader().hide();
                if (state is VerifyOtpSuccess) {
                  if (widget.otpReason == OtpReason.signUp) {
                    NetworkToast.handleSuccess("Account verified successfully");
                    GoRouter.of(context).goNamed(AuthRoutes.signIn);
                  } else {
                    NetworkToast.handleSuccess("Login successful");
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
                    "OTP Verification",
                    style: getTextTheme(context).headlineLarge,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Enter OTP sent to ${widget.email}",
                    style: getTextTheme(
                      context,
                    ).bodyLarge?.copyWith(color: AppColors.lightGray),
                  ),
                  SizedBox(height: 20),
                  AppTextInput(
                    labelText: "OTP",
                    hintText: "Enter otp",
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    controller: otpController,
                    validator: (v) => AppValidators.defaultValidator(v),
                  ),
                  SizedBox(height: 40),
                  ContainedButton(
                    onPressed: submit,
                    width: double.maxFinite,
                    child: Text("Verify"),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Not yet received?",
                            style: getTextTheme(context).bodyMedium,
                          ),
                          TextSpan(
                            recognizer:
                                TapGestureRecognizer()..onTap = () => {},
                            text: " Resend it",
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
