import 'package:taxify_driver/shared/network/network_service.dart';

class PaymentRepository {
  final NetworkService networkService;

  PaymentRepository({required this.networkService});

  getBanks() async {
    final response = await networkService.get("/payment/banks");

    return response.data;
  }

  resolveAccount({
    required String bankCode,
    required String accountNumber,
  }) async {
    final response = await networkService.get(
      "/payment/resolve-account?account_number=$accountNumber&bank_code=$bankCode",
    );

    return response.data;
  }
}
