import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/presentation/account/bloc/account_bloc.dart';
import 'package:taxify_driver/presentation/auth/pages/otp_verification.dart';
import 'package:taxify_driver/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/utils/validators.dart';
import 'package:taxify_driver/shared/widgets/back_button.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  late TextEditingController _emailController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final user = getIt.get<User>();

    _emailController = TextEditingController(text: user.email);
  }

  void submit() {
    if (_formKey.currentState?.validate() == true) {
      getIt.get<AccountBloc>().add(
        UpdateEmailRequested(email: _emailController.text),
      );
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: AppBackButton()),
      body: SingleChildScrollView(
        padding: AppStyles.defaultPagePadding.copyWith(top: 60),
        child: Form(
          key: _formKey,
          child: BlocListener<AccountBloc, AccountState>(
            bloc: getIt.get<AccountBloc>(),
            listener: (context, state) {
              if (state is UpdateEmailLoading) {
                DialogLoader().show(context);
              } else {
                DialogLoader().hide();
                if (state is UpdateEmailSuccess) {
                  NetworkToast.handleSuccess(
                    "Successful! verify email address",
                  );
                  GoRouter.of(context).pushNamed(
                    AuthRoutes.otpVerification,
                    extra: {
                      "reason": OtpReason.changeEmail,
                      "email": _emailController.text,
                    },
                  );
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email", style: getTextTheme(context).headlineLarge),
                SizedBox(height: 50),
                Text(
                  "You'll use this email to get notifications and recover your account",
                ),
                SizedBox(height: 10),
                AppTextInput(
                  labelText: "Email",
                  hintText: "Enter email",
                  controller: _emailController,
                  validator: (value) => AppValidators.defaultValidator(value),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 40),
                ContainedButton(
                  onPressed: submit,
                  width: double.maxFinite,
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
