import 'package:get_it/get_it.dart';
import 'package:taxify_driver/domain/auth/di.dart';
import 'package:taxify_driver/domain/payment/di.dart';
import 'package:taxify_driver/domain/vehicle/di.dart';
import 'package:taxify_driver/presentation/auth/di.dart';

final getIt = GetIt.instance;

void initApp() {
  setupAuthDomain();
  setupVehicleDomain();
  setupPaymentDomain();

  setupAuthPresentaion();
}
