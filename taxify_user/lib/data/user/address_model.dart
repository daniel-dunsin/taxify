enum PresetAddresses { home, work }

class LatLng {
  final double? latitude;
  final double? longitude;

  const LatLng(this.latitude, this.longitude);

  @override
  String toString() => 'LatLng($latitude, $longitude)';

  List<double?> toJson() => [longitude, latitude];

  factory LatLng.fromJson(List<dynamic> json) {
    // monogo db sotres, lang lat
    return LatLng(json[1] as double?, json[0] as double?);
  }
}

class LocationModel {
  String type;
  LatLng coordinates;
  LocationModel({required this.type, required this.coordinates});

  LocationModel copyWith({String? type, LatLng? coordinates}) {
    return LocationModel(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'type': type, 'coordinates': coordinates.toJson()};
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      type: map['type'] as String,
      coordinates: LatLng.fromJson(map["coordinates"]),
    );
  }
}

class AddressModel {
  String? id;
  String? country;
  String? countryIso;
  String? state;
  String? city;
  String? streetAddress;
  String? name;
  String? placeId;
  String? placeDescription;
  String? placeFullText;
  bool isHomeAddress;
  bool isWorkAddress;
  LocationModel? location;

  AddressModel({
    this.country,
    this.countryIso,
    this.state,
    this.city,
    this.streetAddress,
    this.name,
    this.location,
    this.placeId,
    this.placeDescription,
    this.placeFullText,
    this.id,
    required this.isHomeAddress,
    required this.isWorkAddress,
  });

  AddressModel copyWith({
    String? id,
    String? country,
    String? countryIso,
    String? state,
    String? city,
    String? streetAddress,
    String? name,
    String? placeId,
    String? placeDescription,
    String? placeFullText,
    bool? isHomeAddress,
    bool? isWorkAddress,
    LocationModel? location,
  }) {
    return AddressModel(
      id: id ?? this.id,
      country: country ?? this.country,
      countryIso: countryIso ?? this.countryIso,
      state: state ?? this.state,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      placeDescription: placeDescription ?? this.placeDescription,
      placeFullText: placeFullText ?? this.placeFullText,
      isHomeAddress: isHomeAddress ?? this.isHomeAddress,
      isWorkAddress: isWorkAddress ?? this.isWorkAddress,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'state': state,
      'city': city,
      'street_address': streetAddress,
      'name':
          isHomeAddress
              ? PresetAddresses.home.name
              : isWorkAddress
              ? PresetAddresses.work.name
              : name,
      'location_coordinates': location?.coordinates.toJson(),
      "country_iso": countryIso ?? "",
      "place_id": placeId,
      "place_full_text": placeFullText,
      "place_description": placeDescription,
    };
  }

  factory AddressModel.fromMap(Map map) {
    return AddressModel(
      id: map["_id"],
      country: map['country'] != null ? map['country'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      streetAddress:
          map['street_address'] != null
              ? map['street_address'] as String
              : null,
      name: map['name'] != null ? map['name'] as String : null,
      isHomeAddress: map['name'] == PresetAddresses.home,
      isWorkAddress: map["name"] == PresetAddresses.work,
      location:
          map["location"] != null
              ? LocationModel.fromMap(map["location"])
              : null,
      countryIso: map["country_iso"],
      placeId: map["place_id"],
      placeFullText: map["place_full_text"],
      placeDescription: map["place_description"],
    );
  }

  String format() {
    final parts =
        [
          streetAddress,
          city,
          state,
          country,
          countryIso,
        ].where((part) => part != null && part.trim().isNotEmpty).toList();

    return placeFullText ?? parts.join(', ');
  }
}
