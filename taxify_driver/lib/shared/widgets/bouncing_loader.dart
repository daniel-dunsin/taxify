import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/widgets/logo.dart';

class BouncingLoader extends StatefulWidget {
  const BouncingLoader({super.key});

  @override
  State<BouncingLoader> createState() => _BouncingLoaderState();
}

class _BouncingLoaderState extends State<BouncingLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.decelerate),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(scale: _animation.value, child: child);
      },
      child: Logo(),
    );
  }
}
