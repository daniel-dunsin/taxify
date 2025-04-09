import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/auth/auth_repository.dart';
import 'package:taxify_driver/shared/network/network_service.dart';

void setupAuthDomain() {
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(networkService: NetworkService(hasAuth: true)),
  );
}
