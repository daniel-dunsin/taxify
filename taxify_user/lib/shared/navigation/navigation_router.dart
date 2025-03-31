import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/modules/auth/pages/login.dart';
import 'package:taxify_user/modules/auth/pages/otp_verification.dart';
import 'package:taxify_user/modules/auth/pages/sign_up.dart';
import 'package:taxify_user/modules/auth/routes/auth_routes.dart';
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
    GoRoute(
      path: AuthRoutes.signIn,
      name: AuthRoutes.signIn,
      pageBuilder: (context, state) {
        return MaterialPage(child: LoginPage());
      },
    ),
    GoRoute(
      path: AuthRoutes.signUp,
      name: AuthRoutes.signUp,
      pageBuilder: (context, state) {
        return MaterialPage(child: SignUpPage());
      },
    ),
    GoRoute(
      path: AuthRoutes.otpVerification,
      name: AuthRoutes.otpVerification,
      pageBuilder: (context, state) {
        final OtpReason otpReason = (state.extra as Map)["reason"];

        return MaterialPage(child: OtpVerificationPage(otpReason: otpReason));
      },
    ),
  ],

  initialLocation: OnboardingRoutes.splash,
);
