import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/auth/sign_up_steps.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/navigation/navigation_router.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/camera_widget.dart';

class SignUpStep2 extends StatelessWidget {
  const SignUpStep2({super.key});

  void updateProfilePicture(File? profilePicture) {
    getIt.get<SignUpStepsBloc>().add(
      UpdateSignUpStepsData(
        getIt.get<SignUpStepsBloc>().state.signUpModel.copyWith(
          profilePicture: profilePicture,
          enforceNullFile: true,
        ),
      ),
    );
  }

  void submit() {
    getIt.get<SignUpStepsBloc>().add(IncreaseSignUpSteps());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpStepsBloc, SignUpSteps>(
      bloc: getIt.get<SignUpStepsBloc>(),
      builder: (context, state) {
        final profilePicture = state.signUpModel.profilePicture;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Upload picture", style: getTextTheme(context).headlineLarge),
            SizedBox(height: 8),
            Text(
              "Take a nice shot, ensure your face shows, this picture would be used for verification",
              style: getTextTheme(
                context,
              ).bodyLarge?.copyWith(color: AppColors.lightGray),
            ),
            SizedBox(height: 20),

            if (profilePicture == null)
              Center(
                child: GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!.push(
                      MaterialPageRoute(
                        builder: (context) {
                          return CameraScreen(
                            onImageCapture:
                                (image) => updateProfilePicture(image),
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: .9.sw,
                    height: min(.8.sw, 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        width: 2,
                        color: getColorSchema(context).onPrimary,
                      ),
                      color: getColorSchema(context).secondary,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.photo_camera_outlined,
                        size: 45,
                        color: getColorSchema(context).onPrimary,
                      ),
                    ),
                  ),
                ),
              ),

            if (profilePicture != null)
              Container(
                width: .9.sw,
                height: min(.8.sw, 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 2,
                    color: getColorSchema(context).onPrimary,
                  ),
                  color: getColorSchema(context).secondary,
                ),
                child: Image.file(
                  profilePicture,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),

            if (profilePicture != null || (kDebugMode && Platform.isIOS)) ...[
              SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: AppOutlinedButton(
                      onPressed: () {
                        updateProfilePicture(null);
                      },
                      child: Text("Delete Image"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ContainedButton(
                      onPressed: submit,
                      child: Text("Continue"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
