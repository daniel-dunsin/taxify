import 'dart:io';

import 'package:flutter/material.dart';

class FileUploader extends StatelessWidget {
  final File? uploadedFile;
  final Function(File? uploadedFile) onUploadFile;
  final VoidCallback onRemoveFile;
  final String placeholder;

  const FileUploader({
    super.key,
    this.uploadedFile,
    required this.onUploadFile,
    required this.onRemoveFile,
    this.placeholder = "Upload",
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
