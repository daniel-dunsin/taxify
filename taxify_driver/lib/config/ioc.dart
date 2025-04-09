import 'package:get_it/get_it.dart';
import 'package:taxify_driver/domain/auth/di.dart';
import 'package:taxify_driver/domain/payment/di.dart';
import 'package:taxify_driver/domain/user/di.dart';
import 'package:taxify_driver/domain/vehicle/di.dart';
import 'package:taxify_driver/presentation/account/di.dart';
import 'package:taxify_driver/presentation/auth/di.dart';
import 'package:taxify_driver/shared/di.dart';

final getIt = GetIt.instance;

Future<void> initApp() async {
  setupAuthDomain();
  setupVehicleDomain();
  setupPaymentDomain();
  setupUserDomain();

  setupAuthPresentaion();
  setupAccountPresentation();
  setupSharedModule();
}
