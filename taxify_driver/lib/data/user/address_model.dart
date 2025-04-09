enum PresetAddresses { home, work }

class LocationModel {
  String type;
  List<double> coordinates;
  LocationModel({required this.type, required this.coordinates});

  LocationModel copyWith({String? type, List<double>? coordinates}) {
    return LocationModel(
      type: type ?? this.type,
      coordinates: coordinates ?? this.coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'type': type, 'coordinates': coordinates};
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      type: map['type'] as String,
      coordinates: List<double>.from((map['coordinates'] as List<dynamic>)),
    );
  }
}

class AddressModel {
  String id;
  String? country;
  String? countryIso;
  String? state;
  String? city;
  String? streetAddress;
  String? name;
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
    required this.id,
    required this.isHomeAddress,
    required this.isWorkAddress,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'state': state,
      'city': city,
      'streetAddress': streetAddress,
      'name': name,
      'isHomeAddress': isHomeAddress,
      'isWorkAddress': isWorkAddress,
      'location': location?.toMap(),
      "countryIso": countryIso,
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
    );
  }
}
