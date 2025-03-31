import 'package:flutter/material.dart';
import 'package:taxify_driver/data/auth/sign_up_model.dart';
import 'package:taxify_driver/data/auth/verify_otp_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxify_driver/domain/auth/auth_repository.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitialState()) {
    on<SignUpRequested>((event, emit) async {
      emit(SignUpLoading());

      try {
        await authRepository.signUp(event.signUpModel);

        emit(SignUpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(SignUpFailed());
      }
    });

    on<RequestLoginOtpRequested>((event, emit) async {
      emit(RequestLoginLoading());

      try {
        final response = await authRepository.requestLoginOtp(
          event.phoneNumber,
        );

        final bool isVerified = response["data"]?["is_verified"];
        final String? email = response["data"]?["email"];

        emit(RequestLoginSuccess(isVerified: isVerified, email: email));
      } catch (e) {
        NetworkToast.handleError(e);
        emit(RequestLoginFailed());
      }
    });

    on<VerifySignUpOtpRequested>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        await authRepository.verifySignUpOtp(event.verifyOtpModel);

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });

    on<VerifyLoginOtpRequested>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        await authRepository.verifySignInOtp(event.verifyOtpModel);

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });
  }
}
