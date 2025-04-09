part of 'account_bloc.dart';

@immutable
sealed class AccountState {}

class AccountInitialState extends AccountState {}

class UpdateNameLoading extends AccountState {}

class UpdateNameSuccess extends AccountState {}

class UpdateNameFailed extends AccountState {}

class UpdateEmailLoading extends AccountState {}

class UpdateEmailSuccess extends AccountState {}

class UpdateEmailFailed extends AccountState {}

class UpdatePhoneNumberLoading extends AccountState {}

class UpdatePhoneNumberSuccess extends AccountState {}

class UpdatePhoneNumberFailed extends AccountState {}

class UpdateProfilePictureLoading extends AccountState {}

class UpdateProfilePictureSuccess extends AccountState {}

class UpdateProfilePictureFailed extends AccountState {}
