class SignUpModel {
  final String email;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  SignUpModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  SignUpModel copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) {
    return SignUpModel(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }
}
