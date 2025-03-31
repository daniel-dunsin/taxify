import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/auth/auth_repository.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc.dart';

void setupAuthPresentaion() {
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(authRepository: getIt.get<AuthRepository>()),
  );
}
