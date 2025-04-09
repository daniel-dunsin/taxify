import 'package:flutter/material.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/auth/sign_up_model.dart';
import 'package:taxify_user/data/auth/verify_otp_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxify_user/data/user/user_model.dart';
import 'package:taxify_user/domain/auth/auth_repository.dart';
import 'package:taxify_user/domain/user/user_repository.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/network/network_toast.dart';
import 'package:taxify_user/shared/storage/storage.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthBloc({required this.authRepository, required this.userRepository})
    : super(AuthInitialState()) {
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
        final response = await authRepository.verifySignInOtp(
          event.verifyOtpModel,
        );

        final accessToken = response["data"]["access_token"] as String;

        await AppStorage.saveString(
          key: AppStorageConstants.accessToken,
          value: accessToken,
        );

        await userRepository.getAndRegisterUser();

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });

    on<VerifyEmailUpdateOtpRequested>((event, emit) async {
      emit(VerifyOtpLoading());

      try {
        await userRepository.verifyEmailUpdateOtp(event.verifyOtpModel);

        await userRepository.getAndRegisterUser();

        emit(VerifyOtpSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(VerifyOtpFailed());
      }
    });

    on<GetUserRequested>((event, emit) async {
      emit(GetUserLoading());

      try {
        final response = await userRepository.getUser();

        final User user = User.fromMap(response?["data"]);

        if (getIt.isRegistered<User>()) {
          getIt.unregister<User>();
        }

        getIt.registerSingleton<User>(user);
        emit(GetUserSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(GetUserFailed());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(SignOutLoading());

      try {
        await authRepository.signOut();

        await AppStorage.removeObject(key: AppStorageConstants.accessToken);
        getIt.unregister<User>();

        emit(SignOutSuccess());
      } catch (e) {
        NetworkToast.handleError(e);
        emit(SignOutFailed());
      }
    });
  }
}
