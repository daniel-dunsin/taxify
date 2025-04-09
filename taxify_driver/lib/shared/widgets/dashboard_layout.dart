import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxify_driver/config/ioc.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

class DashboardLayout extends StatefulWidget {
  final StatefulNavigationShell shell;

  const DashboardLayout({super.key, required this.shell});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  @override
  void initState() {
    if (getIt.isRegistered<StatefulNavigationShell>()) {
      getIt.unregister<StatefulNavigationShell>();
    }

    getIt.registerSingleton<StatefulNavigationShell>(widget.shell);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
        // splashFactory: NoSplash.splashFactory,
        splashColor: getColorSchema(context).secondary,
      ),
      child: Scaffold(
        body: widget.shell,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.shell.currentIndex,
          onTap: (page) {
            if (widget.shell.currentIndex == page) {
              widget.shell.goBranch(page, initialLocation: true);
            } else {
              widget.shell.goBranch(page);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              checkLightMode(context)
                  ? Theme.of(context).scaffoldBackgroundColor
                  : getColorSchema(context).primary,
          elevation: 4,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: getTextTheme(
            context,
          ).labelLarge?.copyWith(color: getColorSchema(context).onPrimary),
          unselectedLabelStyle: getTextTheme(
            context,
          ).labelMedium?.copyWith(color: getColorSchema(context).onPrimary),
          selectedItemColor: getColorSchema(context).onPrimary,
          unselectedItemColor:
              checkLightMode(context) ? Colors.grey[600] : Colors.grey[500],
          selectedIconTheme: Theme.of(
            context,
          ).iconTheme.copyWith(color: getColorSchema(context).onPrimary),
          unselectedIconTheme: Theme.of(context).iconTheme.copyWith(
            color:
                checkLightMode(context) ? Colors.grey[600] : Colors.grey[500],
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_repair_service),
              label: "Services",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_activity),
              label: "Activity",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),
      ),
    );
  }
}
