import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'JsonUtil.dart';

class FileUtil {
  static String _removeQueryString(String path) {
    return path.substring(0, path.indexOf("?"));
  }

  static String getFileName(String path) {
    return basename(_removeQueryString(path));
  }

  static String getFileNameWithoutExtension(String path) {
    return basenameWithoutExtension(_removeQueryString(path));
  }

  static String getExtension(String path) {
    return extension(_removeQueryString(path));
  }

  static Future<File> downloadFile(String downloadUrl,
      {String? filePath}) async {
    Uint8List uint8list =
        (await NetworkAssetBundle(Uri.parse(downloadUrl)).load(downloadUrl))
            .buffer
            .asUint8List();
    return await File(filePath ?? getFileName(downloadUrl))
        .writeAsBytes(uint8list);
  }

  static void writeFile(String filePath, String text) {
    File(filePath).writeAsStringSync(text);
  }

  static String readFile(String filePath) {
    return File(filePath).readAsStringSync();
  }

  static Map<String, dynamic> readJsonFile(String filePath) {
    String text = readFile(filePath);
    try {
      return JsonUtil.decode(text);
    } catch (e) {
      return {};
    }
  }
}
