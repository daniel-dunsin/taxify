import 'package:get_it/get_it.dart';
import 'package:taxify_user/domain/auth/di.dart';
import 'package:taxify_user/domain/user/di.dart';
import 'package:taxify_user/presentation/account/di.dart';
import 'package:taxify_user/presentation/auth/di.dart';

final getIt = GetIt.instance;

void initApp() {
  setupAuthDomain();
  setupUserDomain();

  setupAuthPresentaion();
  setupAccountPresentation();
}
