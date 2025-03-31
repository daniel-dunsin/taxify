import 'package:flutter/material.dart';

enum OtpReason { login, signUp }

class OtpVerificationPage extends StatelessWidget {
  final OtpReason otpReason;
  const OtpVerificationPage({super.key, required this.otpReason});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
