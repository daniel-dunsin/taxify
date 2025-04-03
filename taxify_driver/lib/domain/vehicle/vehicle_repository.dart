// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:taxify_driver/shared/network/network_service.dart';

class VehicleRepository {
  final NetworkService networkService;
  final NetworkService nhtsaNetworkService;

  VehicleRepository({
    required this.networkService,
    required this.nhtsaNetworkService,
  });

  getVehicleCategories() async {
    final response = await networkService.get("/vehicle/category");

    return response.data;
  }

  getVehicleMakes(String vehicleType) async {
    final response = await nhtsaNetworkService.get(
      "/GetMakesForVehicleType/$vehicleType?format=json",
    );

    return response.data["Results"];
  }

  getVehicleModels({
    required String vehicleMake,
    required int? year,
    required String vehicleType,
  }) async {
    final response = await nhtsaNetworkService.get(
      year == null
          ? "/GetModelsForMakeYear/make/$vehicleMake/vehicletype/$vehicleType?format=json"
          : "/GetModelsForMakeYear/make/$vehicleMake/modelyear/$year/vehicletype/$vehicleType?format=json",
    );

    return response.data["Results"];
  }
}
