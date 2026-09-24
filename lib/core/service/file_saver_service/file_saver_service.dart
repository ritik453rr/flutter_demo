import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';

class FileSaverService {
  static Future<String?> saveBytesToFile(
      List<int> bytes,
      String fileName,
      ) async {
    try {
      final Uint8List uint8List = Uint8List.fromList(bytes);
      final int dotIndex = fileName.lastIndexOf('.');

      final String nameWithoutExtension = dotIndex != -1
          ? fileName.substring(0, dotIndex)
          : fileName;

      final String extension = dotIndex != -1
          ? fileName.substring(dotIndex + 1)
          : 'xlsx';

      final String? savedPath = await FileSaver.instance.saveAs(
        name: nameWithoutExtension,
        bytes: uint8List,
        fileExtension: extension,
        includeExtension: true,
        mimeType: MimeType.microsoftExcel,
      );
      return savedPath;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      return null;
    }
  }
}
