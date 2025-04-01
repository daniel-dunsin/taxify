import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/button.dart';

class SignUpStep3 extends StatefulWidget {
  const SignUpStep3({super.key});

  @override
  State<SignUpStep3> createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController ninNumber;
  File? birthCertificate;
  File? nin;
  File? driversLicenseFrontImage;
  File? driversLicenseBackImage;

  @override
  void initState() {
    super.initState();

    final data = getIt.get<SignUpStepsBloc>().state.signUpModel;

    ninNumber = TextEditingController(text: data.ninNumber);
    setState(() {
      birthCertificate = data.birthCertificate;
      nin = data.nin;
      driversLicenseFrontImage = data.driversLicenseFrontImage;
      driversLicenseBackImage = data.driversLicenseBackImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Verify documents", style: getTextTheme(context).headlineLarge),
        SizedBox(height: 8),
        Text(
          "Submit for documents for verification",
          style: getTextTheme(
            context,
          ).bodyLarge?.copyWith(color: AppColors.lightGray),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
