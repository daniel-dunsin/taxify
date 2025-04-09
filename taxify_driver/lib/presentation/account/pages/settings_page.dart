import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/shared/account_settings_tile_model.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/presentation/account/pages/profile_page.dart';
import 'package:taxify_driver/presentation/account/widgets/appearance_bottom_sheet.dart';
import 'package:taxify_driver/presentation/auth/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxify_driver/presentation/onboarding/routes/onboarding_routes.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/cubits/app_cubit.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/bottom_sheet.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';
import 'package:taxify_driver/shared/widgets/image.dart';

class SettingsPageUtil {
  static open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      builder: (context) {
        return SettingsPage();
      },
    );
  }

  static List<AccountSettingsTileModel> getSettingsTile(BuildContext context) {
    ThemeMode themeMode = getIt.get<AppCubit>().appThemeMode;

    return [
      AccountSettingsTileModel(
        icon: Icons.lock,
        title: "Privacy",
        subtitle: "Manage the data you share with us",
      ),
      AccountSettingsTileModel(
        icon: Icons.accessibility,
        title: "Accessibility",
        subtitle: "Manage your accessibility settings",
      ),
      AccountSettingsTileModel(
        icon: Icons.location_pin,
        title: "Communications",
        subtitle:
            "Choose your preferred contact methods and manage your notification settings",
      ),
      AccountSettingsTileModel(
        icon: Icons.invert_colors,
        title: "Appearance",
        subtitle:
            themeMode == ThemeMode.system
                ? "Use device settings"
                : themeMode == ThemeMode.dark
                ? "Dark Mode"
                : "Light Mode",
        onClick:
            () => AppBottomSheet.displayStatic(
              context,
              height: 400,
              child: AppearanceBottomSheet(),
            ),
      ),
    ];
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  User user = getIt.get<User>();

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

    animation = Tween<double>(begin: 1.sh, end: 0).animate(animationController)
      ..addListener(() {
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
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return BottomSheet(
            backgroundColor: getColorSchema(context).primary,
            onClosing: () {
              animationController.forward();
            },
            constraints: BoxConstraints(
              minHeight: min(1.sh, animation.value),
              maxHeight: animation.value,
              maxWidth: double.infinity,
              minWidth: double.infinity,
            ),
            showDragHandle: false,
            enableDrag: false,
            animationController: animationController,
            builder:
                (context) => Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: GoRouter.of(context).pop,
                      icon: Icon(Icons.close, size: 28),
                    ),
                  ),
                  body: SingleChildScrollView(
                    padding: AppStyles.defaultPagePadding.copyWith(
                      top: 10,
                      bottom: 50,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 40),
                        _buildProfile(),
                        SizedBox(height: 30),
                        _buildSettingsTiles(),
                      ],
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }

  _buildHeader() {
    return Text("Settings", style: getTextTheme(context).headlineLarge);
  }

  _buildProfile() {
    return ListTile(
      onTap: () => ProfilePageUtil.open(context),
      contentPadding: EdgeInsets.all(0),
      leading: AppCircularImage(image: user.profilePicture, radius: 30),
      titleAlignment: ListTileTitleAlignment.center,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "${user.firstName} ${user.lastName}",
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            user.phoneNumber,
            style: getTextTheme(
              context,
            ).labelLarge?.copyWith(color: getColorSchema(context).onSecondary),
          ),
          Text(
            user.email,
            overflow: TextOverflow.ellipsis,
            style: getTextTheme(
              context,
            ).labelLarge?.copyWith(color: getColorSchema(context).onSecondary),
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: getColorSchema(context).onSecondary,
      ),
      horizontalTitleGap: 20,
    );
  }

  _buildSettingsTiles() {
    final tiles = SettingsPageUtil.getSettingsTile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < tiles.length; i++) ...[
          ListTile(
            leading: Icon(
              tiles[i].icon,
              size: 20,
              color: getColorSchema(context).onSecondary,
            ),
            title: Text(tiles[i].title, style: getTextTheme(context).bodyLarge),
            subtitle:
                tiles[i].subtitle != null
                    ? Text(
                      tiles[i].subtitle!,
                      style: getTextTheme(context).labelLarge?.copyWith(
                        color: getColorSchema(context).onSecondary,
                      ),
                    )
                    : null,
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            minTileHeight: 0,
            minVerticalPadding: 0,
            onTap:
                tiles[i].onClick == null
                    ? () => NetworkToast.handleInfo("Coming soon 🙃")
                    : () => tiles[i].onClick!(),
            trailing: Icon(
              Icons.chevron_right,
              color: getColorSchema(context).onSecondary,
            ),
          ),
          Divider(
            thickness: i == tiles.length - 1 ? 1.5 : .3,
            color: getColorSchema(context).onSecondary,
          ),
        ],

        SizedBox(height: 10),

        BlocListener<AuthBloc, AuthState>(
          bloc: getIt.get<AuthBloc>(),
          listener: (context, state) {
            if (state is SignOutLoading) {
              DialogLoader().show(context);
            } else {
              DialogLoader().hide();
              if (state is SignOutSuccess) {
                NetworkToast.handleSuccess("Signed out");
                GoRouter.of(context).pop();
                GoRouter.of(context).goNamed(OnboardingRoutes.onboarding);
              }
            }
          },
          child: GestureDetector(
            onTap: () {
              getIt.get<AuthBloc>().add(SignOutRequested());
            },
            child: Text(
              "Sign Out",
              style: getTextTheme(
                context,
              ).bodyLarge?.copyWith(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
