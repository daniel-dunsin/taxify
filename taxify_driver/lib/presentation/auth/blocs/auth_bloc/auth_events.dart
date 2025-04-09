// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvents {}

class RequestLoginOtpRequested extends AuthEvents {
  final String phoneNumber;

  RequestLoginOtpRequested({required this.phoneNumber});
}

class SignUpRequested extends AuthEvents {
  SignUpRequested();
}

class VerifySignUpOtpRequested extends AuthEvents {
  final VerifyOtpModel verifyOtpModel;

  VerifySignUpOtpRequested(this.verifyOtpModel);
}

class VerifyLoginOtpRequested extends AuthEvents {
  final VerifyOtpModel verifyOtpModel;

  VerifyLoginOtpRequested(this.verifyOtpModel);
}

class VerifyEmailUpdateOtpRequested extends AuthEvents {
  final VerifyOtpModel verifyOtpModel;

  VerifyEmailUpdateOtpRequested(this.verifyOtpModel);
}

class GetVehicleCategoriesRequested extends AuthEvents {}

class GetVehicleMakesRequested extends AuthEvents {
  final String vehicleType;

  GetVehicleMakesRequested({required this.vehicleType});
}

class GetVehicleModelsRequested extends AuthEvents {
  final int? vehicleYear;
  final String vehicleType;
  final String vehicleMake;

  GetVehicleModelsRequested({
    required this.vehicleYear,
    required this.vehicleType,
    required this.vehicleMake,
  });
}

class GetBanksRequested extends AuthEvents {
  GetBanksRequested();
}

class ResolveAccountRequested extends AuthEvents {
  final String accountNumber;
  final String bankCode;

  ResolveAccountRequested({
    required this.accountNumber,
    required this.bankCode,
  });
}

class GetUserRequested extends AuthEvents {
  GetUserRequested();
}

class SignOutRequested extends AuthEvents {}
