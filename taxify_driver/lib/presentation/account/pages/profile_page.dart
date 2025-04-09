import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/presentation/account/widgets/profile_page_home.dart';
import 'package:taxify_driver/presentation/account/widgets/profile_page_personal_info.dart';
import 'package:taxify_driver/presentation/account/widgets/profile_page_privacy.dart';
import 'package:taxify_driver/presentation/account/widgets/profile_page_security.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class ProfilePageTabController extends TabController {
  ProfilePageTabController({
    super.initialIndex = 0,
    super.animationDuration,
    required super.length,
    required super.vsync,
  });
}

class ProfilePageUtil {
  static open(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      builder: (context) {
        return ProfilePage();
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late ProfilePageTabController _tabController;

  @override
  void initState() {
    if (!getIt.isRegistered<ProfilePageTabController>()) {
      _tabController = ProfilePageTabController(length: 4, vsync: this);
      getIt.registerSingleton<ProfilePageTabController>(_tabController);
    } else {
      _tabController = getIt.get<ProfilePageTabController>();
    }

    _tabController =
        _tabController..addListener(() {
          if (_tabController.indexIsChanging) {
            setState(() {});
          }
        });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    getIt.unregister<ProfilePageTabController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      backgroundColor: getColorSchema(context).primary,
      onClosing: () {},
      showDragHandle: false,
      constraints: BoxConstraints(
        minHeight: double.infinity,
        maxHeight: double.infinity,
      ),
      enableDrag: false,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: GoRouter.of(context).pop,
              icon: Icon(Icons.close, size: 28),
            ),
            title: Text(
              "Taxify Account",
              style: getTextTheme(context).bodyLarge,
            ),
          ),
          body: Column(children: [_buildTabs(), _buildTabView()]),
        );
      },
    );
  }

  _buildTabs() {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelStyle: getTextTheme(context).labelLarge,
      padding: EdgeInsets.all(0),
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorWeight: 4,
      dividerHeight: 4,
      dividerColor: getColorSchema(context).secondary,
      indicatorColor: getColorSchema(context).onPrimary,
      tabs: [
        Tab(text: "Home"),
        Tab(text: "Personal info"),
        Tab(text: "Security"),
        Tab(text: "Privacy & data"),
      ],
      controller: _tabController,
    );
  }

  _buildTabView() {
    return SingleChildScrollView(
      padding: AppStyles.defaultPagePadding,
      child:
          [
            ProfilePageHome(),
            ProfilePagePersonalInfo(),
            ProfilePageSecurity(),
            ProfilePagePrivacy(),
          ][_tabController.index],
    );
  }
}
