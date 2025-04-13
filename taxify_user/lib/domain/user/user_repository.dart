import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/auth/verify_otp_model.dart';
import 'package:taxify_user/data/user/address_model.dart';
import 'package:taxify_user/data/user/user_model.dart';
import 'package:taxify_user/shared/network/network_service.dart';

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

  Future saveDeviceToken(String token) async {
    final response = await networkService.put(
      "/user/device-token",
      data: {"deviceToken": token},
    );

    return response.data;
  }

  Future createAddress(AddressModel address) async {
    final response = await networkService.post(
      "/user/address",
      data: address.toMap(),
    );

    return response.data;
  }

  Future getAddresses() async {
    final response = await networkService.get("/user/address");

    return response.data;
  }

  Future updateAddress(AddressModel address) async {
    final response = await networkService.put(
      "/user/address/${address.id}",
      data: address.toMap(),
    );

    return response.data;
  }

  Future deleteAddress(String addressId) async {
    final response = await networkService.delete("/user/address/$addressId");

    return response.data;
  }
}
