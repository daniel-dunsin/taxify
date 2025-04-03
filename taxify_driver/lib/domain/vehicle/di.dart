import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/domain/vehicle/vehicle_repository.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_service.dart';

void setupVehicleDomain() {
  getIt.registerSingleton<VehicleRepository>(
    VehicleRepository(
      networkService: NetworkService(hasAuth: true),
      nhtsaNetworkService: NetworkService(
        baseUrl: AppConstants.nhtsaServerBaseUrl,
      ),
    ),
  );
}
