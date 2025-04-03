import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/network/network_toast.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/back_button.dart';
import 'package:taxify_driver/shared/widgets/button.dart';
import 'package:taxify_driver/shared/widgets/dialog_loader.dart';

class CameraScreen extends StatefulWidget {
  final Function(File? image) onImageCapture;
  const CameraScreen({super.key, required this.onImageCapture});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? controller;
  CameraDescription? cameraDescription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  _initializeCamera({CameraDescription? cameraDescription}) async {
    DialogLoader().show(context);
    await grantPermission(Permission.camera);
    _cameras = await availableCameras().catchError(
      (error) => List<CameraDescription>.from([]),
    );

    if (_cameras.isEmpty) {
      DialogLoader().hide();
      return NetworkToast.handleError("No camera found");
    }

    CameraDescription selectedCamera =
        cameraDescription ??
        (_cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras.first,
        ));

    try {
      final newController = CameraController(
        selectedCamera,
        ResolutionPreset.max,
      );

      await newController.initialize();

      setState(() {
        controller = newController;
      });
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            NetworkToast.handleError("Camera access denied");
            break;
          default:
            break;
        }
      }
    }

    DialogLoader().hide();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(cameraDescription: cameraController.description);
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("controller description ${controller?.description}");
    return Scaffold(
      appBar: AppBar(leading: AppBackButton(), toolbarHeight: 50),
      body: Padding(
        padding: EdgeInsets.only(bottom: 100, left: 20, right: 20),
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Container(
                width: double.maxFinite,
                height: min(300, .5.sh),
                color: getColorSchema(context).onPrimary,
                child:
                    controller?.description == null
                        ? SizedBox.shrink()
                        : CameraPreview(controller!),
              ),
              Spacer(),
              ContainedButton(
                onPressed: () async {
                  final XFile? imageFile = await controller?.takePicture();

                  widget.onImageCapture(File(imageFile!.path));
                  context.pop();
                },
                width: double.maxFinite,
                backgroundColor: AppColors.accent,
                disabled: controller == null,
                child: Text("Capture"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
