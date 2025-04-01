import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/auth/sign_up_steps.dart';
import 'package:taxify_driver/presentation/auth/blocs/sign_up_steps_bloc/sign_up_steps_bloc.dart';
import 'package:taxify_driver/presentation/auth/widgets/sign_up_step_1.dart';
import 'package:taxify_driver/presentation/auth/widgets/sign_up_step_2.dart';
import 'package:taxify_driver/presentation/auth/widgets/sign_up_step_3.dart';
import 'package:taxify_driver/presentation/auth/widgets/sign_up_step_4.dart';
import 'package:taxify_driver/presentation/auth/widgets/sign_up_step_5.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/back_button.dart';
import 'package:taxify_driver/shared/widgets/logo.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpStepsBloc, SignUpSteps>(
      bloc: getIt.get<SignUpStepsBloc>(),
      builder: (context, state) {
        final currentStep = state.step;
        return Scaffold(
          appBar: AppBar(
            leading: AppBackButton(
              onPressed: () {
                if (currentStep == 1) {
                  GoRouter.of(context).pop();
                } else {
                  getIt.get<SignUpStepsBloc>().add(DecreaseSignUpSteps());
                }
              },
            ),
            title: Logo(),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppStyles.defaultPagePadding.copyWith(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      for (int i = 1; i <= 5; i++) ...[
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (i < currentStep) {
                                getIt.get<SignUpStepsBloc>().add(
                                  SetSignUpSteps(i),
                                );
                              }
                            },
                            child: Container(
                              width: double.maxFinite,
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color:
                                    currentStep == i
                                        ? getColorSchema(context).onPrimary
                                        : AppColors.lightGray,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                      ],
                    ],
                  ),
                  SizedBox(height: 30),
                  [
                    SignUpStep1(),
                    SignUpStep2(),
                    SignUpStep3(),
                    SignUpStep4(),
                    SignUpStep5(),
                  ][currentStep - 1],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
