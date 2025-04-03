class VehicleMakeModel {
  int id;
  String name;

  VehicleMakeModel({required this.id, required this.name});

  VehicleMakeModel copyWith({int? id, String? name}) {
    return VehicleMakeModel(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory VehicleMakeModel.fromMap(Map<String, dynamic> map) {
    return VehicleMakeModel(
      id: map['MakeId'] as int,
      name: map['MakeName'] as String,
    );
  }
}
