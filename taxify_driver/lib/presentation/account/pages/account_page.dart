import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/data/user/user_model.dart';
import 'package:taxify_driver/presentation/account/pages/profile_page.dart';
import 'package:taxify_driver/presentation/account/pages/settings_page.dart';
import 'package:taxify_driver/presentation/account/routes/account_routes.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/routes/shared_routes.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 30),
              _buildTabs(),
              SizedBox(height: 15),
              Divider(color: getColorSchema(context).onPrimary, thickness: 2),
              SizedBox(height: 15),
              _buildAccountListTile(
                title: "Family",
                icon: Icons.family_restroom,
                subtitle: "Manage a family profile",
              ),
              _buildAccountListTile(
                title: "Settings",
                icon: Icons.settings,
                onClick: () => SettingsPageUtil.open(context),
              ),
              _buildAccountListTile(title: "Messages", icon: Icons.mail),
              _buildAccountListTile(
                title: "Earn by driving or delivering",
                icon: Icons.drive_eta_outlined,
              ),
              _buildAccountListTile(title: "Saved groups", icon: Icons.people),
              _buildAccountListTile(
                title: "Setup your business profile",
                icon: Icons.cases_rounded,
                subtitle: "Automate work travel & expenses",
              ),
              _buildAccountListTile(title: "Legal", icon: Icons.info),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    User user = getIt.get<User>();

    return Row(
      children: [
        Expanded(
          child: Text(
            "${user.firstName} ${user.lastName}",
            style: getTextTheme(context).headlineLarge,
          ),
        ),
        SizedBox(width: 50),
        GestureDetector(
          onTap: () => ProfilePageUtil.open(context),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            backgroundImage: CachedNetworkImageProvider(user.profilePicture),
            radius: 30,
          ),
        ),
      ],
    );
  }

  _buildTabs() {
    return Row(
      children: [
        _buildSingleTab(
          title: "Help",
          icon: Icons.help,
          onClick: () {
            GoRouter.of(context).pushNamed(
              SharedRoutes.webView,
              extra: {"url": "https://help.uber.com", "title": "Help"},
            );
          },
        ),
        SizedBox(width: 10),
        _buildSingleTab(
          title: "Wallet",
          icon: Icons.wallet,
          onClick: () => GoRouter.of(context).pushNamed(AccountRoutes.wallet),
        ),
        SizedBox(width: 10),
        _buildSingleTab(
          title: "Activity",
          icon: Icons.local_activity,
          onClick: () {
            // route to activity branch
            getIt.get<StatefulNavigationShell>().goBranch(2);
          },
        ),
      ],
    );
  }

  _buildSingleTab({
    VoidCallback? onClick,
    required String title,
    required IconData icon,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getColorSchema(context).secondary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: getColorSchema(context).onSecondary),
              SizedBox(height: 5),
              Text(title, style: getTextTheme(context).bodyLarge),
            ],
          ),
        ),
      ),
    );
  }

  _buildAccountListTile({
    VoidCallback? onClick,
    required String title,
    required IconData icon,
    String? subtitle,
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
      ),
    );
  }
}
