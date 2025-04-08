import 'package:taxify_user/config/ioc.dart';
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
}
