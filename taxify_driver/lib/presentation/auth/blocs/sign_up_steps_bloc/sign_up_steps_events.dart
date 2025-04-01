part of 'sign_up_steps_bloc.dart';

@immutable
sealed class SignUpStepsEvents {}

class IncreaseSignUpSteps extends SignUpStepsEvents {}

class DecreaseSignUpSteps extends SignUpStepsEvents {}

class ResetSignUpStepsState extends SignUpStepsEvents {}

class SetSignUpSteps extends SignUpStepsEvents {
  final int step;

  SetSignUpSteps(this.step);
}

class UpdateSignUpStepsData extends SignUpStepsEvents {
  final SignUpModel signUpModel;

  UpdateSignUpStepsData(this.signUpModel);
}
