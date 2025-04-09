import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/presentation/account/bloc/account_bloc.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/utils/validators.dart';
import 'package:taxify_driver/shared/widgets/back_button.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  const ChangePhoneNumberPage({super.key});

  @override
  State<ChangePhoneNumberPage> createState() => _ChangePhoneNumberPageState();
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  late TextEditingController _phoneNumberController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final user = getIt.get<User>();

    _phoneNumberController = TextEditingController(text: user.phoneNumber);
  }

  void submit() {
    if (_formKey.currentState?.validate() == true) {
      getIt.get<AccountBloc>().add(
        UpdatePhoneNumberRequested(phoneNumber: _phoneNumberController.text),
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
              if (state is UpdatePhoneNumberLoading) {
                DialogLoader().show(context);
              } else {
                DialogLoader().hide();
                if (state is UpdatePhoneNumberSuccess) {
                  NetworkToast.handleSuccess("Profile updated successfully");
                  GoRouter.of(context).pop();
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone Number",
                  style: getTextTheme(context).headlineLarge,
                ),
                SizedBox(height: 50),
                Text(
                  "You'll use this number to sign in, get notifications and recover your account",
                ),
                SizedBox(height: 10),
                AppTextInput(
                  labelText: "Phone Number",
                  hintText: "Enter phone number",
                  controller: _phoneNumberController,
                  validator: (value) => AppValidators.defaultValidator(value),
                  keyboardType: TextInputType.phone,
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
