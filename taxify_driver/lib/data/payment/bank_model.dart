class BankModel {
  String name;
  String code;
  String logo;
  BankModel({required this.name, required this.code, required this.logo});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'code': code, 'logo': logo};
  }

  factory BankModel.fromMap(Map map) {
    return BankModel(
      name: map['name'] as String,
      code: map['code'] as String,
      logo: map['logo'] as String,
    );
  }
}
