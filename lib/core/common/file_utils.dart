import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';

class FileUtiles {
  static Future<String> get _cacheDirectory async {
    final directory = await getApplicationCacheDirectory();

    return directory.path;
  }

  static Future<File> writeFiletoCache(String filePath, String json) async {
    final directoryPath = await _cacheDirectory;
    final file = File('$directoryPath/$filePath');

    // Write the file
    return file.writeAsString(json);
  }

  static Future<String> readFileFromCache(String filePath) async {
    try {
      final directoryPath = await _cacheDirectory;
      final file = File('$directoryPath/$filePath');

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }

  static Future<String> createCacheFileFromBase64Data(Uint8List bytes,
      {required String fileName}) async {
    String dir = (await getApplicationCacheDirectory()).path;
    File file = File("$dir/$fileName");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<String> saveFileToFolder(Uint8List bytes,
      {required String fileName, required String fileType}) async {
    return await FileSaver().saveAs(
            name: fileName.split('.').first,
            bytes: bytes,
            ext: 'pdf',
            mimeType: MimeType.pdf) ??
        '';
  }
}
