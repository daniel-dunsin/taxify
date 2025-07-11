import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/domain/user/user_repository.dart';
import 'package:taxify_user/shared/cubits/app_cubit.dart';

void setupSharedModule() {
  getIt.registerSingleton<AppCubit>(
    AppCubit(userRepository: getIt.get<UserRepository>()),
  );
}
