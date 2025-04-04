import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/payment/bank_model.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/presentation/auth/pages/otp_verification.dart';
import 'package:taxify_driver/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_driver/presentation/auth/widgets/bank_selector_bottom_sheet.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/extenstions/extensions.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/utils/validators.dart';
import 'package:taxify_driver/shared/widgets/bottom_sheet.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/input_decorator.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class SignUpStep5 extends StatefulWidget {
  const SignUpStep5({super.key});

  @override
  State<SignUpStep5> createState() => _SignUpStep5State();
}

class _SignUpStep5State extends State<SignUpStep5> {
  List<BankModel> banks = [];
  BankModel? bank;
  late TextEditingController accountNumberController;
  String? accountName;

  @override
  void initState() {
    super.initState();

    final data = getIt.get<SignUpStepsBloc>().state.signUpModel;
    setState(() {
      accountName = data.accountName;
      bank = data.bank;
    });
    accountNumberController = TextEditingController(text: data.accountNumber)
      ..addListener(() {
        setState(() {
          accountName = null;
        });
        if (accountNumberController.text.length == 10 && bank != null) {
          resolveAccount.call();
        }
      });

    getIt.get<AuthBloc>().add(GetBanksRequested());
  }

  void resolveAccount() {
    getIt.get<AuthBloc>().add(
      ResolveAccountRequested(
        accountNumber: accountNumberController.text,
        bankCode: bank?.code as String,
      ),
    );
  }

  void submit() {
    getIt.get<SignUpStepsBloc>().add(
      UpdateSignUpStepsData(
        getIt.get<SignUpStepsBloc>().state.signUpModel.copyWith(
          accountName: accountName,
          accountNumber: accountNumberController.text,
          bank: bank,
        ),
      ),
    );

    getIt.get<AuthBloc>().add(SignUpRequested());
  }

  void onSignUpSuccess() {
    NetworkToast.handleSuccess("Sign up successful");
    GoRouter.of(context).goNamed(
      AuthRoutes.otpVerification,
      extra: {
        "email": getIt.get<SignUpStepsBloc>().state.signUpModel.email,
        "reason": OtpReason.signUp,
      },
    );
    getIt.get<SignUpStepsBloc>().add(ResetSignUpStepsState());
  }

  @override
  void dispose() {
    accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add Bank Details", style: getTextTheme(context).headlineLarge),
        SizedBox(height: 8),
        Text(
          "Add bank details for receiving payouts.",
          style: getTextTheme(
            context,
          ).bodyLarge?.copyWith(color: AppColors.lightGray),
        ),
        SizedBox(height: 20),

        BlocConsumer<AuthBloc, AuthState>(
          bloc: getIt.get<AuthBloc>(),
          listener: (context, state) {
            if (state is GetBanksLoading ||
                state is ResolveAccountLoading ||
                state is SignUpLoading) {
              DialogLoader().show(context);
            } else if (state is GetBanksFailed ||
                state is ResolveAccountFailed ||
                state is SignUpFailed) {
              DialogLoader().hide();
            } else if (state is GetBanksSuccess) {
              DialogLoader().hide();
              setState(() {
                banks = state.data;
              });
            } else if (state is ResolveAccountSuccess) {
              DialogLoader().hide();
              setState(() {
                accountName = state.accountName;
              });
            } else if (state is SignUpSuccess) {
              DialogLoader().hide();
              onSignUpSuccess.call();
            }
          },
          builder: (context, state) {
            return Form(
              child: Column(
                children: [
                  _buildBanks(),
                  SizedBox(height: 10),
                  _buildAccountNumber(),
                  SizedBox(height: 10),
                  _buildAccountName(),
                  SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  _buildBanks() {
    return AppTextInputDecorator(
      labelText: "Bank",
      value: bank?.name,
      prefixIcon:
          bank != null
              ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  bank?.logo as String,
                ),
                radius: 15,
              )
              : null,
      hintText: "Select bank",
      onClick: () {
        AppBottomSheet.displayStatic(
          context,
          child: BankSelectorBottomSheet(
            banks: banks,
            onSelectBank: (selectedBank) {
              setState(() {
                bank = selectedBank;
                accountName = null;
              });
            },
          ),
          height: .8.sh,
        );
      },
      onCancel: () {
        setState(() {
          bank = null;
          accountName = null;
        });
      },
    );
  }

  _buildAccountNumber() {
    return AppTextInput(
      controller: accountNumberController,
      labelText: "Account Number",
      maxLength: 10,
      hintText: bank == null ? "Select bank first" : "Enter account number",
      disabled: bank == null,
      validator: (value) => AppValidators.defaultValidator(value),
      keyboardType: TextInputType.number,
    );
  }

  _buildAccountName() {
    return AppTextInputDecorator(
      disabled: true,
      suffixIcon:
          accountName != null
              ? Icon(Icons.check_circle_outline, color: AppColors.success)
              : Icon(Icons.cancel_outlined, color: AppColors.error),
      value: accountName?.captalize ?? "Not verified",
      labelText: "Account Name",
    );
  }

  _buildSubmitButton() {
    return ContainedButton(
      disabled:
          accountName == null ||
          accountNumberController.text.isEmpty ||
          bank == null,
      onPressed: submit,
      width: double.maxFinite,
      child: Text("Complete sign up"),
    );
  }
}
