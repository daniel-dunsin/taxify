import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/presentation/account/pages/account_page.dart';
import 'package:taxify_user/presentation/account/pages/add_location_page.dart';
import 'package:taxify_user/presentation/account/pages/change_email.dart';
import 'package:taxify_user/presentation/account/pages/change_name_page.dart';
import 'package:taxify_user/presentation/account/pages/change_phone_number.dart';
import 'package:taxify_user/presentation/account/pages/change_profile_picture.dart';
import 'package:taxify_user/presentation/account/pages/save_custom_location.dart';
import 'package:taxify_user/presentation/account/pages/saved_locations.dart';
import 'package:taxify_user/presentation/account/pages/wallet_page.dart';
import 'package:taxify_user/presentation/account/routes/account_routes.dart';
import 'package:taxify_user/presentation/activity/pages/activity_page.dart';
import 'package:taxify_user/presentation/activity/routes/activity_routes.dart';
import 'package:taxify_user/presentation/auth/pages/login.dart';
import 'package:taxify_user/presentation/auth/pages/otp_verification.dart';
import 'package:taxify_user/presentation/auth/pages/sign_up.dart';
import 'package:taxify_user/presentation/auth/routes/auth_routes.dart';
import 'package:taxify_user/presentation/home/pages/home_page.dart';
import 'package:taxify_user/presentation/home/routes/home_routes.dart';
import 'package:taxify_user/presentation/onboarding/pages/onboarding.dart';
import 'package:taxify_user/presentation/onboarding/pages/splash.dart';
import 'package:taxify_user/presentation/onboarding/routes/onboarding_routes.dart';
import 'package:taxify_user/presentation/services/pages/services_page.dart';
import 'package:taxify_user/presentation/services/routes/services_routes.dart';
import 'package:taxify_user/shared/routes/shared_routes.dart';
import 'package:taxify_user/shared/widgets/dashboard_layout.dart';
import 'package:taxify_user/shared/widgets/webview.dart';

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
        final Map extra = state.extra as Map;
        final OtpReason otpReason = extra["reason"];
        final String email = extra["email"];

        return MaterialPage(
          child: OtpVerificationPage(otpReason: otpReason, email: email),
        );
      },
    ),

    StatefulShellRoute.indexedStack(
      pageBuilder:
          (context, state, shell) =>
              MaterialPage(child: DashboardLayout(shell: shell)),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: HomeRoutes.index,
              name: HomeRoutes.index,
              pageBuilder: (context, state) {
                return MaterialPage(child: HomePage());
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ServicesRoutes.index,
              name: ServicesRoutes.index,
              pageBuilder:
                  (context, state) => MaterialPage(child: ServicesPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: ActivityRoutes.index,
              name: ActivityRoutes.index,
              pageBuilder:
                  (context, state) => MaterialPage(child: ActivityPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AccountRoutes.index,
              name: AccountRoutes.index,
              pageBuilder:
                  (context, state) => MaterialPage(child: AccountPage()),
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: AccountRoutes.wallet,
      name: AccountRoutes.wallet,
      pageBuilder: (context, state) => MaterialPage(child: WalletPage()),
    ),

    GoRoute(
      path: SharedRoutes.webView,
      name: SharedRoutes.webView,
      pageBuilder: (context, state) {
        final extra = state.extra as Map;
        return MaterialPage(
          child: WebPage(webPageUrl: extra["url"], title: extra["title"]),
        );
      },
    ),

    GoRoute(
      path: AccountRoutes.changeName,
      name: AccountRoutes.changeName,
      pageBuilder: (context, state) {
        return MaterialPage(child: ChangeNamePage());
      },
    ),

    GoRoute(
      path: AccountRoutes.changeEmail,
      name: AccountRoutes.changeEmail,
      pageBuilder: (context, state) {
        return MaterialPage(child: ChangeEmailPage());
      },
    ),

    GoRoute(
      path: AccountRoutes.changeNumber,
      name: AccountRoutes.changeNumber,
      pageBuilder: (context, state) {
        return MaterialPage(child: ChangePhoneNumberPage());
      },
    ),

    GoRoute(
      path: AccountRoutes.changeProfilePicture,
      name: AccountRoutes.changeProfilePicture,
      pageBuilder: (context, state) {
        return MaterialPage(child: ChangeProfilePicturePage());
      },
    ),

    GoRoute(
      path: AccountRoutes.addLocation,
      name: AccountRoutes.addLocation,
      pageBuilder: (context, state) {
        final Map? extra = state.extra as Map?;
        return MaterialPage(
          child: AddLocationPage(
            isUpdating: extra?["isUpdating"] ?? false,
            address: extra?["address"],
            presetName: extra?["presetName"],
            onSelect: extra?["onSelect"],
          ),
        );
      },
    ),

    GoRoute(
      path: AccountRoutes.saveCustomLocation,
      name: AccountRoutes.saveCustomLocation,
      pageBuilder: (context, state) {
        final Map? extra = state.extra as Map?;
        return MaterialPage(
          child: SaveCustomLocationPage(
            isUpdating: extra?["isUpdating"],
            address: extra?["address"],
            presetName: extra?["presetName"],
          ),
        );
      },
    ),

    GoRoute(
      path: AccountRoutes.savedLocations,
      name: AccountRoutes.savedLocations,
      pageBuilder: (context, state) {
        return MaterialPage(child: SavedLocationsPage());
      },
    ),
  ],

  initialLocation: OnboardingRoutes.splash,
);
