import 'package:flutter/foundation.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/auth/verify_otp_model.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/shared/network/network_service.dart';

class UserRepository {
  final NetworkService networkService;

  UserRepository({required this.networkService});

  Future<Map>? getUser() async {
    final response = await networkService.get("/user");

    return response.data;
  }

  Future<User> getAndRegisterUser() async {
    final response = await getUser();

    final User user = User.fromMap(response?["data"]);

    if (getIt.isRegistered<User>()) {
      getIt.unregister<User>();
    }

    getIt.registerSingleton<User>(user);

    return user;
  }

  Future<Map>? verifyEmailUpdateOtp(VerifyOtpModel data) async {
    final response = await networkService.put(
      "/user/email/verify",
      data: data.toMap(),
    );

    return response.data;
  }

  Future requestEmailUpdate(String email) async {
    final response = await networkService.put(
      "/user/email/request",
      data: {"email": email},
    );

    return response.data;
  }

  Future updateNames({
    required String firstName,
    required String lastName,
  }) async {
    final response = await networkService.put(
      "/user",
      data: {"firstName": firstName, "lastName": lastName},
    );

    return response.data;
  }

  Future updatePhoneNumber({required String phoneNumber}) async {
    final response = await networkService.put(
      "/user",
      data: {"phoneNumber": phoneNumber},
    );

    return response.data;
  }

  Future updateProfilePicture(String profilePicture) async {
    final response = await networkService.put(
      "/user",
      data: {"profilePicture": profilePicture},
    );

    return response.data;
  }
}
