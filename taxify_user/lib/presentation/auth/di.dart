import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/domain/auth/auth_repository.dart';
import 'package:taxify_user/presentation/auth/blocs/auth_bloc.dart';

void setupAuthPresentaion() {
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(authRepository: getIt.get<AuthRepository>()),
  );
}
