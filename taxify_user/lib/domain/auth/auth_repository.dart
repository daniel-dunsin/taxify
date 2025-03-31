import 'package:taxify_user/data/auth/sign_up_model.dart';
import 'package:taxify_user/data/auth/verify_otp_model.dart';
import 'package:taxify_user/shared/network/network_service.dart';

class AuthRepository {
  final NetworkService networkService;

  AuthRepository({required this.networkService});

  signUp(SignUpModel signUpModel) async {
    final response = await networkService.post(
      "/auth/sign-up/user",
      data: signUpModel.toMap(),
    );

    return response.data;
  }

  verifySignUpOtp(VerifyOtpModel verifyOtpModel) async {
    final response = await networkService.post(
      "/auth/verify-account",
      data: verifyOtpModel.toMap(),
    );

    return response.data;
  }

  requestLoginOtp(String phoneNumber) async {
    final response = await networkService.post(
      "/auth/request-login-otp",
      data: {"phone_number": phoneNumber, "role": "User"},
    );

    return response.data;
  }

  verifySignInOtp(VerifyOtpModel verifyOtpModel) async {
    final response = await networkService.post(
      "/auth/login-with-otp",
      data: verifyOtpModel.toMap(),
    );

    return response.data;
  }
}
