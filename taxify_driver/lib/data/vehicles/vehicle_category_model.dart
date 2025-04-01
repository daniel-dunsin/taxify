class VehicleCategoryModel {
  final String id;
  final String name;
  final String? image;
  final String? mapImage;
  VehicleCategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.mapImage,
  });

  factory VehicleCategoryModel.fromMap(Map<String, dynamic> map) {
    return VehicleCategoryModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      mapImage: map['map_image'] != null ? map['map_image'] as String : null,
    );
  }
}
