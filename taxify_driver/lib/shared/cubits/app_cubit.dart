import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxify_driver/data/shared/app_model.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/storage/storage.dart';

class AppCubit extends Cubit<AppModel> {
  AppCubit() : super(AppModel());

  Future<void> initAppTheme() async {
    String? themeModeFromLocalStorage = await AppStorage.getString(
      key: AppStorageConstants.themeMode,
    );

    if (themeModeFromLocalStorage == null) {
      themeModeFromLocalStorage = ThemeMode.system.name;
      await AppStorage.saveString(
        key: AppStorageConstants.themeMode,
        value: themeModeFromLocalStorage,
      );
    }

    final ThemeMode themeMode = ThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeFromLocalStorage,
    );

    emit(state.copyWith(themeMode: themeMode));
  }

  void changeAppTheme(ThemeMode themeMode) async {
    await AppStorage.saveString(
      key: AppStorageConstants.themeMode,
      value: themeMode.name,
    );
    emit(state.copyWith(themeMode: themeMode));
  }

  ThemeMode get appThemeMode {
    if (state.themeMode == null) {
      return ThemeMode.system;
    } else {
      return state.themeMode!;
    }
  }
}
