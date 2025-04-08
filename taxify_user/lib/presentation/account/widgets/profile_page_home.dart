import 'package:flutter/material.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/data/user/user_model.dart';
import 'package:taxify_user/presentation/account/pages/profile_page.dart';
import 'package:taxify_user/shared/utils/utils.dart';
import 'package:taxify_user/shared/widgets/image.dart';

class ProfilePageHome extends StatefulWidget {
  const ProfilePageHome({super.key});

  @override
  State<ProfilePageHome> createState() => _ProfilePageHomeState();
}

class _ProfilePageHomeState extends State<ProfilePageHome> {
  final ProfilePageTabController tabController =
      getIt.get<ProfilePageTabController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildHeader(),
        SizedBox(height: 40),
        _buildRouters(),
      ],
    );
  }

  _buildHeader() {
    final user = getIt.get<User>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppCircularImage(image: user.profilePicture, radius: 40),
          SizedBox(height: 10),
          Text(user.firstName, style: getTextTheme(context).headlineLarge),
          SizedBox(height: 8),
          Text(
            user.email,
            style: getTextTheme(
              context,
            ).bodySmall?.copyWith(color: getColorSchema(context).onSecondary),
          ),
        ],
      ),
    );
  }

  _buildRouters() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1.5,
          color: getColorSchema(context).onSecondary,
        ),
      ),
      child: Column(
        children: [
          _buildRouterListTile(
            tabIndex: 1,
            icon: Icons.person_outlined,
            title: "Personal info",
            subtitle: "Name, phone & email",
          ),
          _buildRouterListTile(
            tabIndex: 2,
            icon: Icons.security,
            title: "Security",
            subtitle: "Change Password",
          ),
          _buildRouterListTile(
            tabIndex: 3,
            icon: Icons.lock,
            title: "Privacy & data",
            subtitle: "Privacy centre, third-party apps",
          ),
        ],
      ),
    );
  }

  _buildRouterListTile({
    required int tabIndex,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 20,
          color: getColorSchema(context).onSecondary,
        ),
        title: Text(title, style: getTextTheme(context).bodyLarge),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        minTileHeight: 0,
        minVerticalPadding: 0,
        subtitle: Text(
          subtitle,
          style: getTextTheme(
            context,
          ).labelLarge?.copyWith(color: getColorSchema(context).onSecondary),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: getColorSchema(context).onSecondary,
        ),
        onTap: () => tabController.animateTo(tabIndex),
      ),
    );
  }
}
