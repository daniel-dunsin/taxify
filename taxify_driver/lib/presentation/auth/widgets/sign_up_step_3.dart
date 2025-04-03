import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/file_uploader.dart';
import 'package:taxify_driver/shared/widgets/text_input.dart';

class SignUpStep3 extends StatefulWidget {
  const SignUpStep3({super.key});

  @override
  State<SignUpStep3> createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController ninNumberController;
  File? birthCertificate;
  File? nin;
  File? driversLicenseFrontImage;
  File? driversLicenseBackImage;

  @override
  void initState() {
    super.initState();

    final data = getIt.get<SignUpStepsBloc>().state.signUpModel;

    ninNumberController = TextEditingController(text: data.ninNumber);
    setState(() {
      birthCertificate = data.birthCertificate;
      nin = data.nin;
      driversLicenseFrontImage = data.driversLicenseFrontImage;
      driversLicenseBackImage = data.driversLicenseBackImage;
    });
  }

  void submit() {
    if (ninNumberController.text.trim().isEmpty ||
        ![
          birthCertificate,
          nin,
          driversLicenseFrontImage,
          driversLicenseBackImage,
        ].every((c) => c != null)) {
      return NetworkToast.handleError("Fill all fields");
    }

    getIt.get<SignUpStepsBloc>().add(
      UpdateSignUpStepsData(
        getIt.get<SignUpStepsBloc>().state.signUpModel.copyWith(
          nin: nin,
          ninNumber: ninNumberController.text,
          birthCertificate: birthCertificate,
          driversLicenseFrontImage: driversLicenseFrontImage,
          driversLicenseBackImage: driversLicenseBackImage,
        ),
      ),
    );

    getIt.get<SignUpStepsBloc>().add(IncreaseSignUpSteps());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Verify documents", style: getTextTheme(context).headlineLarge),
        SizedBox(height: 8),
        Text(
          "Submit your documents for verification",
          style: getTextTheme(
            context,
          ).bodyLarge?.copyWith(color: AppColors.lightGray),
        ),
        SizedBox(height: 20),

        AppTextInput(
          controller: ninNumberController,
          labelText: "National ID Number",
          hintText: "Enter national identification number",
        ),

        SizedBox(height: 10),

        FileUploader(
          uploadedFile: nin,
          onUploadFile: (file) {
            setState(() {
              nin = file;
            });
          },
          onRemoveFile: () {
            setState(() {
              nin = null;
            });
          },
          label: "National ID Image",
        ),

        SizedBox(height: 10),

        FileUploader(
          uploadedFile: birthCertificate,
          onUploadFile: (file) {
            setState(() {
              birthCertificate = file;
            });
          },
          onRemoveFile: () {
            setState(() {
              birthCertificate = null;
            });
          },
          label: "Birth Certificate",
        ),

        SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FileUploader(
                uploadedFile: driversLicenseFrontImage,
                onUploadFile: (file) {
                  setState(() {
                    driversLicenseFrontImage = file;
                  });
                },
                onRemoveFile: () {
                  setState(() {
                    driversLicenseFrontImage = null;
                  });
                },
                label: "Drivers license front",
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: FileUploader(
                uploadedFile: driversLicenseBackImage,
                onUploadFile: (file) {
                  setState(() {
                    driversLicenseBackImage = file;
                  });
                },
                onRemoveFile: () {
                  setState(() {
                    driversLicenseBackImage = null;
                  });
                },
                label: "Drivers license back",
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        ContainedButton(
          onPressed: submit,
          width: double.maxFinite,
          child: Text("Continue"),
        ),
      ],
    );
  }
}
