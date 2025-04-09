import 'package:get_it/get_it.dart';
import 'package:taxify_user/domain/auth/di.dart';
import 'package:taxify_user/domain/user/di.dart';
import 'package:taxify_user/presentation/account/di.dart';
import 'package:taxify_user/presentation/auth/di.dart';
import 'package:taxify_user/shared/di.dart';

final getIt = GetIt.instance;

Future<void> initApp() async {
  setupAuthDomain();
  setupUserDomain();

  setupAuthPresentaion();
  setupAccountPresentation();
  setupSharedModule();
}
