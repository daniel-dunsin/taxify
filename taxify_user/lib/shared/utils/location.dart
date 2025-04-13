import 'package:flutter_google_maps_webservices/places.dart';
import 'package:taxify_user/data/user/address_model.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:location/location.dart' as location;

enum AddressType {
  city("locality"),
  state("administrative_area_level_1"),
  country("country");

  final String googleType;
  const AddressType(this.googleType);
}

class LocationUtils {
  final _placesSdk = GoogleMapsPlaces(apiKey: AppConstants.googleMapApiKey);

  Future<List<Prediction>> getPredictions(String query) async {
    final deviceLocation = await _getDeviceLocation();

    final predictions = await _placesSdk.autocomplete(
      query,
      origin: Location.fromJson({
        "lat": deviceLocation?.latitude,
        "lng": deviceLocation?.longitude,
      }),
    );

    predictions.predictions.sort(
      (a, b) => a.distanceMeters?.compareTo(b.distanceMeters ?? 0) ?? 0,
    );

    return predictions.predictions;
  }

  Future<PlacesDetailsResponse> getPlace(String placeId) async {
    final place = await _placesSdk.getDetailsByPlaceId(placeId);

    return place;
  }

  String? getAddressComponent(
    List<AddressComponent> components,
    AddressType addressType,
  ) {
    try {
      return components
          .firstWhere((c) => c.types.contains(addressType.googleType))
          .longName;
    } catch (e) {
      return null;
    }
  }

  Future<LatLng?> _getDeviceLocation() async {
    final serviceEnabled = await location.Location().serviceEnabled();

    if (serviceEnabled) {
      final permissionStatus = await location.Location().hasPermission();
      if (permissionStatus == location.PermissionStatus.granted ||
          permissionStatus == location.PermissionStatus.grantedLimited) {
        final userLocation = await location.Location().getLocation();

        return LatLng(userLocation.latitude, userLocation.longitude);
      }
    }

    return null;
  }

  static String formatDistance(int meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      double km = meters / 1000;
      return km % 1 == 0
          ? '${km.toStringAsFixed(0)} km'
          : '${km.toStringAsFixed(2)} km';
    }
  }
}
