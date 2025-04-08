import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/domain/user/user_repository.dart';
import 'package:taxify_user/shared/network/network_service.dart';

void setupUserDomain() {
  getIt.registerSingleton<UserRepository>(
    UserRepository(networkService: NetworkService(hasAuth: true)),
  );
}
