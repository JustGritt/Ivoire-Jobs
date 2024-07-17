import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:barassage_app/core/exceptions/file_exception.dart';
import 'dart:io';

Future<File> compressAndGetFile(File file) async {
  final filePath = file.absolute.path;
  final outPath =
      '${filePath.substring(0, filePath.lastIndexOf('/'))}/${DateTime.now().millisecondsSinceEpoch}_out.jpeg';

  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    quality: 10,
  );
  if (result == null) {
    throw FileException('File compression failed');
  }
  return File(result.path);
}
