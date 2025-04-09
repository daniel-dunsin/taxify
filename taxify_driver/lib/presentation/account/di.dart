import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/user/user_repository.dart';
import 'package:taxify_driver/presentation/account/bloc/account_bloc.dart';

void setupAccountPresentation() {
  getIt.registerSingleton<AccountBloc>(
    AccountBloc(userRepository: getIt.get<UserRepository>()),
  );
}
