import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:taxify_driver/data/auth/sign_up_model.dart';
import 'package:taxify_driver/data/auth/sign_up_steps.dart';

part 'sign_up_steps_events.dart';

class SignUpStepsBloc extends Bloc<SignUpStepsEvents, SignUpSteps> {
  SignUpStepsBloc() : super(SignUpSteps(step: 4, signUpModel: SignUpModel())) {
    on<IncreaseSignUpSteps>((event, emit) {
      emit(state.copyWith(step: state.step == 5 ? 5 : state.step + 1));
    });

    on<DecreaseSignUpSteps>((event, emit) {
      emit(state.copyWith(step: state.step == 1 ? 1 : state.step - 1));
    });

    on<SetSignUpSteps>((event, emit) {
      emit(state.copyWith(step: event.step));
    });

    on<ResetSignUpStepsState>((event, emit) {
      emit(SignUpSteps(step: 1, signUpModel: SignUpModel()));
    });

    on<UpdateSignUpStepsData>((event, emit) {
      emit(state.copyWith(signUpModel: event.signUpModel));
    });
  }
}
