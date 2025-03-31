import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/modules/onboarding/routes/onboarding_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = GoRouter.of(context);

      Future.delayed(
        Duration(seconds: 3),
      ).then((data) => router.pushNamed(OnboardingRoutes.onboarding));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: .02.sh),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  "assets/images/logo-small.png",
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            Image.asset("assets/images/logo.png", width: 150),
          ],
        ),
      ),
    );
  }
}
