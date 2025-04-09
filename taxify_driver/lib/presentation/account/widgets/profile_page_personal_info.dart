import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/presentation/account/routes/account_routes.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/image.dart';

class ProfilePagePersonalInfo extends StatefulWidget {
  const ProfilePagePersonalInfo({super.key});

  @override
  State<ProfilePagePersonalInfo> createState() =>
      _ProfilePagePersonalInfoState();
}

class _ProfilePagePersonalInfoState extends State<ProfilePagePersonalInfo> {
  @override
  Widget build(BuildContext context) {
    final user = getIt.get<User>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personal Info", style: getTextTheme(context).headlineLarge),
        SizedBox(height: 20),
        AppCircularImage(image: user.profilePicture, radius: 50),
        SizedBox(height: 20),
        _buildAccountListTile(
          title: "Name",
          subtitle: "${user.firstName} ${user.lastName}",
          onClick:
              () => GoRouter.of(context).pushNamed(AccountRoutes.changeName),
        ),
        _buildDivider(),
        _buildAccountListTile(
          title: "Phone number",
          subtitle: user.phoneNumber,
          onClick:
              () => GoRouter.of(context).pushNamed(AccountRoutes.changeNumber),
        ),
        _buildDivider(),
        _buildAccountListTile(
          title: "Email",
          subtitle: user.email,
          onClick:
              () => GoRouter.of(context).pushNamed(AccountRoutes.changeEmail),
        ),
        _buildDivider(),
      ],
    );
  }

  _buildDivider() {
    return Divider(color: getColorSchema(context).onSecondary, thickness: .4);
  }

  _buildAccountListTile({
    VoidCallback? onClick,
    required String title,
    String? subtitle,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: ListTile(
        minLeadingWidth: 0,
        title: Text(title, style: getTextTheme(context).bodyLarge),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        minTileHeight: 0,
        minVerticalPadding: 0,
        subtitle:
            subtitle != null
                ? Text(
                  subtitle,
                  style: getTextTheme(context).labelLarge?.copyWith(
                    color: getColorSchema(context).onSecondary,
                  ),
                )
                : null,
        onTap:
            onClick == null
                ? () => NetworkToast.handleInfo("Coming soon 🙃")
                : () => onClick(),
        trailing: Icon(
          Icons.chevron_right,
          color: getColorSchema(context).onSecondary,
        ),
      ),
    );
  }
}
