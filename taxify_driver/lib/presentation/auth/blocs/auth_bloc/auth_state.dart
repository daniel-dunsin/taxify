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

class GetVehicleCategoriesLoading extends AuthState {}

class GetVehicleCategoriesSuccess extends AuthState {
  final List<VehicleCategoryModel> data;

  GetVehicleCategoriesSuccess(this.data);
}

class GetVehicleCategoriesFailed extends AuthState {}

class GetVehicleMakesLoading extends AuthState {}

class GetVehicleMakesSuccess extends AuthState {
  final List<VehicleMakeModel> data;

  GetVehicleMakesSuccess(this.data);
}

class GetVehicleMakesFailed extends AuthState {}

class GetVehicleModelsLoading extends AuthState {}

class GetVehicleModelsSuccess extends AuthState {
  final List<NHTSAVehicleModel> data;

  GetVehicleModelsSuccess(this.data);
}

class GetVehicleModelsFailed extends AuthState {}

class GetBanksLoading extends AuthState {}

class GetBanksSuccess extends AuthState {
  final List<BankModel> data;

  GetBanksSuccess(this.data);
}

class GetBanksFailed extends AuthState {}

class ResolveAccountLoading extends AuthState {}

class ResolveAccountSuccess extends AuthState {
  final String accountNumber;
  final String accountName;

  ResolveAccountSuccess({
    required this.accountNumber,
    required this.accountName,
  });
}

class ResolveAccountFailed extends AuthState {}

class GetUserLoading extends AuthState {}

class GetUserSuccess extends AuthState {}

class GetUserFailed extends AuthState {}

class SignOutLoading extends AuthState {}

class SignOutSuccess extends AuthState {}

class SignOutFailed extends AuthState {}
