class NHTSAVehicleModel {
  int id;
  String name;
  NHTSAVehicleModel({required this.id, required this.name});

  NHTSAVehicleModel copyWith({int? id, String? name}) {
    return NHTSAVehicleModel(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory NHTSAVehicleModel.fromMap(Map<String, dynamic> map) {
    return NHTSAVehicleModel(
      id: map['Model_ID'] as int,
      name: map['Model_Name'] as String,
    );
  }
}
