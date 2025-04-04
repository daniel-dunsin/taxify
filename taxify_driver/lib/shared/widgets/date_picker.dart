import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/bottom_sheet.dart';

class AppDatePicker {
  static Future<DateTime?> adaptive(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    if (Platform.isIOS) {
      final Completer<DateTime?> completer = Completer<DateTime?>();
      DateTime? pickedDate = initialDate;

      AppBottomSheet.displayStatic(
        context,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    completer.complete(pickedDate);
                    GoRouter.of(context).pop();
                  },
                  child: Text(
                    "Done",
                    style: getTextTheme(context).bodyLarge?.copyWith(
                      color: getColorSchema(context).onPrimary,
                    ),
                  ),
                ),
              ),
              StatefulBuilder(
                builder: (context, setState) {
                  return Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: initialDate,
                      maximumDate:
                          lastDate ?? DateTime(DateTime.now().year + 1),
                      minimumDate: firstDate ?? DateTime(1900),
                      onDateTimeChanged: (newDate) {
                        setState(() {
                          pickedDate = newDate;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );

      return await completer.future;
    } else {
      return await showDatePicker(
        context: context,
        firstDate: firstDate ?? DateTime(1900),
        lastDate: lastDate ?? DateTime(DateTime.now().year + 1),
        initialDate: initialDate,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        useRootNavigator: true,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              colorScheme:
                  !checkLightMode(context)
                      ? ColorScheme.dark(primary: AppColors.accent)
                      : ColorScheme.light(primary: AppColors.darkGray),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      checkLightMode(context)
                          ? AppColors.darkGray
                          : AppColors.accent, // button text color
                ),
              ),
            ),

            child: child!,
          );
        },
      );
    }
  }
}
