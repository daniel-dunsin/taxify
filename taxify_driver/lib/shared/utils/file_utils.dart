import 'dart:convert';
import 'dart:io';

class FileUtils {
  static Future<String> convertImageToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64String = base64Encode(imageBytes);

    return base64String;
  }
}
