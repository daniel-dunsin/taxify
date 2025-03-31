import 'package:flutter/material.dart';
import 'package:taxify_user/shared/utils/utils.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final isLightMode = checkLightMode(context);

    return Image.asset(
      isLightMode ? "assets/images/logo.png" : "assets/images/logo-small.png",
      width: isLightMode ? 100 : 50,
    );
  }
}
