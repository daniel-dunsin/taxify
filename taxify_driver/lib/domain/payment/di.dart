import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/payment/payment_repository.dart';
import 'package:taxify_driver/shared/network/network_service.dart';

void setupPaymentDomain() {
  getIt.registerSingleton<PaymentRepository>(
    PaymentRepository(networkService: NetworkService(hasAuth: true)),
  );
}
