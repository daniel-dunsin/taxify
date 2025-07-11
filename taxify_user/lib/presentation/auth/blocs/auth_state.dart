// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

class AuthInitialState extends AuthState {}

class RequestLoginLoading extends AuthState {}

class RequestLoginSuccess extends AuthState {
  final bool isVerified;
  final String? email;

  RequestLoginSuccess({required this.isVerified, this.email});
}

class RequestLoginFailed extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {}

class SignUpFailed extends AuthState {}

class VerifyOtpLoading extends AuthState {}

class VerifyOtpSuccess extends AuthState {}

class VerifyOtpFailed extends AuthState {}

class GetUserLoading extends AuthState {}

class GetUserSuccess extends AuthState {}

class GetUserFailed extends AuthState {}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutFailed extends AuthState {}
