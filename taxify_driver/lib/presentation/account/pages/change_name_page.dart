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

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final user = getIt.get<User>();

    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
  }

  void submit() {
    if (_formKey.currentState?.validate() == true) {
      getIt.get<AccountBloc>().add(
        UpdateNameRequested(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        ),
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
              if (state is UpdateNameLoading) {
                DialogLoader().show(context);
              } else {
                DialogLoader().hide();
                if (state is UpdateNameSuccess) {
                  NetworkToast.handleSuccess("Profile updated successfully");
                  GoRouter.of(context).pop();
                }
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Names", style: getTextTheme(context).headlineLarge),
                SizedBox(height: 50),
                AppTextInput(
                  labelText: "First name",
                  hintText: "Enter first name",
                  controller: _firstNameController,
                  validator: (value) => AppValidators.defaultValidator(value),
                ),
                SizedBox(height: 10),
                AppTextInput(
                  labelText: "Last name",
                  hintText: "Enter last name",
                  controller: _lastNameController,
                  validator: (value) => AppValidators.defaultValidator(value),
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
