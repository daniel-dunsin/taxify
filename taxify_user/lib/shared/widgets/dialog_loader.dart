import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taxify_user/config/ioc.dart';
import 'package:taxify_user/shared/navigation/navigation_router.dart';
import 'package:taxify_user/shared/widgets/bouncing_loader.dart';

class DialogLoader {
  OverlayEntry? _overlayEntry;

  DialogLoader() {
    if (getIt.isRegistered<OverlayEntry>()) {
      _overlayEntry = getIt.get<OverlayEntry>();
    }
  }

  void show(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          child: Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.4)),
            child: Center(child: BouncingLoader()),
          ),
        );
      },
    );

    getIt.registerSingleton<OverlayEntry>(_overlayEntry!);

    Overlay.of(context).insert(_overlayEntry!);
  }

  hide() {
    if (_overlayEntry == null || !getIt.isRegistered<OverlayEntry>()) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    getIt.unregister<OverlayEntry>();
  }
}
