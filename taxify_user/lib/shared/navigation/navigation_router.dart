import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/modules/onboarding/pages/onboarding.dart';
import 'package:taxify_user/modules/onboarding/pages/splash.dart';
import 'package:taxify_user/modules/onboarding/routes/onboarding_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: OnboardingRoutes.onboarding,
      name: OnboardingRoutes.onboarding,
      pageBuilder: (context, state) {
        return MaterialPage(child: OnboardingScreen());
      },
    ),
    GoRoute(
      path: OnboardingRoutes.splash,
      name: OnboardingRoutes.splash,
      pageBuilder: (context, state) {
        return MaterialPage(child: SplashScreen());
      },
    ),
  ],

  initialLocation: OnboardingRoutes.splash,
);
