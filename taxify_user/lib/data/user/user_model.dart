import 'package:taxify_user/data/user/address_model.dart';

class User {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String profilePicture;
  AddressModel? homeAddress;
  AddressModel? workAddress;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    this.homeAddress,
    this.workAddress,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    AddressModel? homeAddress,
    AddressModel? workAddress,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      homeAddress: homeAddress ?? this.homeAddress,
      workAddress: workAddress ?? this.workAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'profilePicture': profilePicture,
      'homeAddress': homeAddress?.toMap(),
      'workAddress': workAddress?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      email: map['email'] as String,
      profilePicture: map['profile_picture'] as String,
      homeAddress:
          map['home_address'] != null
              ? AddressModel.fromMap(
                map['home_address'] as Map<String, dynamic>,
              )
              : null,
      workAddress:
          map['work_address'] != null
              ? AddressModel.fromMap(
                map['work_address'] as Map<String, dynamic>,
              )
              : null,
    );
  }
}
