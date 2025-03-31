import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  final double size;
  const AppBackButton({super.key, this.size = 25});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, size: size),
      onPressed: () {
        GoRouter.of(context).pop();
      },
    );
  }
}
