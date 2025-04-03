// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthEvents {}

class RequestLoginOtpRequested extends AuthEvents {
  final String phoneNumber;

  RequestLoginOtpRequested({required this.phoneNumber});
}

class SignUpRequested extends AuthEvents {
  final SignUpModel signUpModel;

  SignUpRequested(this.signUpModel);
}

class VerifySignUpOtpRequested extends AuthEvents {
  final VerifyOtpModel verifyOtpModel;

  VerifySignUpOtpRequested(this.verifyOtpModel);
}

class VerifyLoginOtpRequested extends AuthEvents {
  final VerifyOtpModel verifyOtpModel;

  VerifyLoginOtpRequested(this.verifyOtpModel);
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
