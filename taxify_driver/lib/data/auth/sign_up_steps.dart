import 'package:taxify_driver/data/auth/sign_up_model.dart';

class SignUpSteps {
  int step;
  SignUpModel signUpModel;

  SignUpSteps({required this.step, required this.signUpModel});

  SignUpSteps copyWith({int? step, SignUpModel? signUpModel}) {
    return SignUpSteps(
      step: step ?? this.step,
      signUpModel: signUpModel ?? this.signUpModel,
    );
  }
}
