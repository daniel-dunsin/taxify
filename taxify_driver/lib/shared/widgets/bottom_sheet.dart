import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class AppBottomSheet {
  static void displayDraggable(BuildContext context, {Widget? child}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: .5,
          minChildSize: .5,
          builder: (context, state) {
            return Container(
              height: double.maxFinite,
              color:
                  checkLightMode(context)
                      ? getColorSchema(context).primary
                      : AppColors.lightGray,
            );
          },
        );
      },
    );
  }

  static void displayStatic(
    BuildContext context, {
    required Widget child,
    double height = 300,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      barrierColor: const Color.fromARGB(106, 114, 114, 114),
      builder: (context) {
        return AppStaticBottomSheet(height: height, child: child);
      },
    );
  }
}

class AppStaticBottomSheet extends StatefulWidget {
  final double height;
  final Widget child;

  const AppStaticBottomSheet({
    super.key,
    required this.height,
    required this.child,
  });

  @override
  State<AppStaticBottomSheet> createState() => _AppStaticBottomSheetState();
}

class _AppStaticBottomSheetState extends State<AppStaticBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        GoRouter.of(context).pop();
      }
    });

    animation = Tween<double>(
      begin: widget.height,
      end: 0,
    ).animate(animationController)..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return BottomSheet(
          backgroundColor: getColorSchema(context).primary,
          onClosing: () {
            animationController.forward();
          },
          constraints: BoxConstraints(
            minHeight: min(200, animation.value),
            maxHeight: animation.value,
            maxWidth: double.infinity,
            minWidth: double.infinity,
          ),
          showDragHandle: true,
          enableDrag: true,
          animationController: animationController,
          builder: (context) => widget.child,
        );
      },
    );
  }
}
