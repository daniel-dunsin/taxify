import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/file_utils.dart';
import 'package:taxify_driver/shared/utils/utils.dart';
import 'package:taxify_driver/shared/widgets/bottom_sheet.dart';

class FileUploader extends StatelessWidget {
  final File? uploadedFile;
  final Function(File? uploadedFile) onUploadFile;
  final VoidCallback onRemoveFile;
  final String placeholder;
  final String? label;

  const FileUploader({
    super.key,
    this.uploadedFile,
    required this.onUploadFile,
    required this.onRemoveFile,
    this.placeholder = "Upload",
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...(label != null
            ? [
              Text(
                label!,
                style: getTextTheme(
                  context,
                ).labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
            ]
            : []),

        ...(uploadedFile == null
            ? [_buildBlankView(context)]
            : [_buildUploadedView(context)]),
      ],
    );
  }

  _buildBlankView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomSheet.displayStatic(
          context,
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt_outlined),
                title: Text("Take a photo"),
                trailing: Icon(
                  Icons.chevron_right,
                  color: getColorSchema(context).onPrimary,
                ),
                onTap: () async {
                  final file = await FileUtils.pickImage(ImageSource.camera);

                  onUploadFile(file);
                  GoRouter.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.file_upload_outlined),
                title: Text("Select from files"),
                trailing: Icon(
                  Icons.chevron_right,
                  color: getColorSchema(context).onPrimary,
                ),
                onTap: () async {
                  final file = await FileUtils.pickFile();

                  onUploadFile(file);
                  GoRouter.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.image_outlined),
                title: Text("Select from gallery"),
                trailing: Icon(
                  Icons.chevron_right,
                  color: getColorSchema(context).onPrimary,
                ),
                onTap: () async {
                  final file = await FileUtils.pickImage(ImageSource.gallery);

                  onUploadFile(file);
                  GoRouter.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      child: Container(
        height: 120,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              checkLightMode(context)
                  ? getColorSchema(context).primary
                  : getColorSchema(context).secondary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              style: BorderStyle.solid,
              color: AppColors.lightGray,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.download_outlined,
                color: getColorSchema(context).onSecondary,
                size: 30,
              ),
              SizedBox(height: 1),
              Text(
                placeholder,
                style: getTextTheme(context).labelLarge?.copyWith(
                  color: getColorSchema(context).onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildUploadedView(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(10),
      color:
          checkLightMode(context)
              ? getColorSchema(context).primary
              : AppColors.darkGray,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              basename(uploadedFile!.path),
              overflow: TextOverflow.ellipsis,
              style: getTextTheme(
                context,
              ).bodyMedium?.copyWith(color: getColorSchema(context).onPrimary),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 1.5,
            height: double.maxFinite,
            decoration: BoxDecoration(color: getColorSchema(context).onPrimary),
          ),

          InkWell(
            onTap: onRemoveFile,
            child: Icon(
              Icons.close,
              size: 24,
              color: getColorSchema(context).onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
