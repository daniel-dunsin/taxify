import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/domain/auth/auth_repository.dart';
import 'package:taxify_user/shared/network/network_service.dart';

void setupAuthDomain() {
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(networkService: NetworkService(hasAuth: true)),
  );
}
