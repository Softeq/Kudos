import 'dart:io';

class FileService {
  static const fileSizeLimit = 5 * 1024 * 1024; // 5 Mb

  Future<bool> isFileSizeValid(File file) async {
    var fileSize = await file.length();
    return fileSize <= fileSizeLimit;
  }
}