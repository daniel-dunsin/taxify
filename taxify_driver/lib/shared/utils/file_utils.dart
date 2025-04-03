import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class FileUtils {
  static Future<String> convertImageToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64String = base64Encode(imageBytes);

    return base64String;
  }

  static Future<File?> pickImage(ImageSource imageSource) async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: imageSource,
    );

    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  static Future<File?> pickFile({FileType fileType = FileType.any}) async {
    final FilePickerResult? pickedFile = await FilePickerIO().pickFiles(
      type: fileType,
      allowMultiple: false,
    );

    if (pickedFile?.files[0] != null) return null;

    return File(pickedFile?.files[0].path as String);
  }
}
