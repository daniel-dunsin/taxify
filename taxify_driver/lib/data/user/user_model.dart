class User {
  String id;
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String profilePicture;
  String driverId;
  bool isOnline;
  bool isVerified;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.driverId,
    required this.isOnline,
    required this.isVerified,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    String? driverId,
    bool? isOnline,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      driverId: driverId ?? this.driverId,
      isOnline: isOnline ?? this.isOnline,
      isVerified: isVerified ?? this.isVerified,
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
      'driverId': driverId,
      'isOnline': isOnline,
      'isVerified': isVerified,
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
      driverId: map['driver_id'] as String,
      isOnline: map['is_online'] as bool,
      isVerified: map['is_verified'] as bool,
    );
  }
}
