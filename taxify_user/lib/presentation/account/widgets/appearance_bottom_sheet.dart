import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/shared/constants/constants.dart';
import 'package:taxify_user/shared/cubits/app_cubit.dart';
import 'package:taxify_user/shared/extenstions/extensions.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/button.dart';

class AppearanceBottomSheet extends StatefulWidget {
  const AppearanceBottomSheet({super.key});

  @override
  State<AppearanceBottomSheet> createState() => _AppearanceBottomSheetState();
}

class _AppearanceBottomSheetState extends State<AppearanceBottomSheet> {
  final ThemeMode currentMode = getIt.get<AppCubit>().appThemeMode;
  ThemeMode selectedMode = getIt.get<AppCubit>().appThemeMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: AppStyles.defaultPagePadding.copyWith(top: 0, bottom: 20),
            child: Text(
              "Appearance",
              style: getTextTheme(
                context,
              ).titleLarge?.copyWith(fontSize: 25.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Divider(
          color: getColorSchema(context).secondary,
          thickness: 1.5,
          height: 0,
        ),
        Padding(
          padding: AppStyles.defaultPagePadding.copyWith(top: 0, bottom: 20),
          child: Column(
            children: [
              ...ThemeMode.values.reversed.map((mode) {
                return RadioListTile(
                  value: mode,
                  groupValue: selectedMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      setState(() {
                        selectedMode = mode;
                      });
                    }
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: getColorSchema(context).onPrimary,
                  selected: mode == selectedMode,
                  title: Row(
                    children: [
                      Icon(
                        mode == ThemeMode.light
                            ? Icons.light_mode_outlined
                            : mode == ThemeMode.dark
                            ? Icons.dark_mode_outlined
                            : Icons.computer,
                        color: getColorSchema(context).onPrimary,
                      ),
                      SizedBox(width: 10),
                      Text(
                        mode.name.capitalize,
                        style: getTextTheme(context).bodyLarge,
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 30),
              ContainedButton(
                onPressed: () {
                  getIt.get<AppCubit>().changeAppTheme(selectedMode);
                  GoRouter.of(context).pop();
                },
                width: double.maxFinite,
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
