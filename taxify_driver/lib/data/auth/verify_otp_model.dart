class VerifyOtpModel {
  String? phoneNumber;
  String? email;
  String otp;
  VerifyOtpModel({this.phoneNumber, this.email, required this.otp});

  VerifyOtpModel copyWith({String? phoneNumber, String? email, String? otp}) {
    return VerifyOtpModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'otp': otp};

    if (phoneNumber != null) {
      map.putIfAbsent("phone_number", () => phoneNumber);
    }
    if (email != null) {
      map.putIfAbsent("email", () => email);
    }

    return map;
  }
}
