import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/config/notifications.dart';
import 'package:taxify_user/data/shared/app_model.dart';
import 'package:taxify_user/shared/cubits/app_cubit.dart';
import 'package:taxify_user/shared/navigation/navigation_router.dart';
import 'package:taxify_user/shared/theme/dark_theme.dart';
import 'package:taxify_user/shared/theme/light_theme.dart';
import 'package:toastification/toastification.dart';

void main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initApp();
  await initLocalNotifications();

  await getIt.get<AppCubit>().initAppTheme();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FlutterNativeSplash.remove(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      ensureScreenSize: true,
      minTextAdapt: true,
      designSize: Size(393, 852),
      builder: (context, state) {
        return BlocBuilder<AppCubit, AppModel>(
          bloc: getIt.get<AppCubit>(),
          builder: (context, state) {
            final ThemeMode themeMode = getIt.get<AppCubit>().appThemeMode;
            return ToastificationWrapper(
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeMode,
                routerDelegate: goRouter.routerDelegate,
                routeInformationParser: goRouter.routeInformationParser,
                routeInformationProvider: goRouter.routeInformationProvider,
              ),
            );
          },
        );
      },
    );
  }
}
