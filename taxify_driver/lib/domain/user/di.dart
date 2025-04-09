import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/user/user_repository.dart';
import 'package:taxify_driver/shared/network/network_service.dart';

void setupUserDomain() {
  getIt.registerSingleton<UserRepository>(
    UserRepository(networkService: NetworkService(hasAuth: true)),
  );
}
