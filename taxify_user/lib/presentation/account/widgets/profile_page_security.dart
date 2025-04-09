import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxify_user/shared/utils/utils.dart';

class ProfilePageSecurity extends StatelessWidget {
  const ProfilePageSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: .35.sh),
      child: Text("Coming Soon!", style: getTextTheme(context).headlineLarge),
    );
  }
}
