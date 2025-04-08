import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/domain/user/user_repository.dart';
import 'package:taxify_user/presentation/account/bloc/account_bloc.dart';

void setupAccountPresentation() {
  getIt.registerSingleton<AccountBloc>(
    AccountBloc(userRepository: getIt.get<UserRepository>()),
  );
}
