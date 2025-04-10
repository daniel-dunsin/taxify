import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_user/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_user/presentation/onboarding/widgets/onboarding_page_scroll.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    _requestPermissions();
    super.initState();
  }

  void _requestPermissions() async {
    await grantPermission(Permission.location);
    await grantPermission(Permission.appTrackingTransparency);
    await requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppStyles.defaultPagePadding.copyWith(bottom: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OnboardingPageScroll(),
            SizedBox(height: 120),
            Column(
              children: [
                ContainedButton(
                  width: double.maxFinite,
                  height: 55,
                  backgroundColor: AppColors.accent,
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AuthRoutes.signIn);
                  },
                  child: Text("Sign In"),
                ),
                SizedBox(height: 30),
                ContainedButton(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AuthRoutes.signUp);
                  },
                  backgroundColor: getColorSchema(context).onPrimary,
                  width: double.maxFinite,
                  height: 55,
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
