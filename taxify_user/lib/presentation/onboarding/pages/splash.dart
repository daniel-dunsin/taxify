import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/user/user_model.dart';
import 'package:taxify_user/domain/user/user_repository.dart';
import 'package:taxify_user/presentation/home/routes/home_routes.dart';
import 'package:taxify_user/presentation/onboarding/routes/onboarding_routes.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/storage/storage.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final router = GoRouter.of(context);
      final accessToken = await AppStorage.getString(
        key: AppStorageConstants.accessToken,
      );

      try {
        if (accessToken == null) {
          throw Error();
        }

        final userResponse = await getIt.get<UserRepository>().getUser();

        if (userResponse == null || userResponse["success"] == false) {
          throw Error();
        }

        if (getIt.isRegistered<User>()) {
          getIt.unregister<User>();
        }

        getIt.registerSingleton<User>(User.fromMap(userResponse["data"]));
        router.goNamed(HomeRoutes.index);
      } catch (e) {
        debugPrint(e.toString());
        if (getIt.isRegistered<User>()) {
          getIt.unregister<User>();
        }
        if (accessToken != null) {
          await AppStorage.removeObject(key: AppStorageConstants.accessToken);
        }
        router.goNamed(OnboardingRoutes.onboarding);
      }
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
