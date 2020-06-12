import 'dart:io';

class FileService {
  static const fileSizeLimit = 5 * 1024 * 1024; // 5 Mb

  Future<bool> isFileSizeValid(File file) async {
    if (file == null)
    {
      return false;
    }
    var fileSize = await file.length();
    return fileSize <= fileSizeLimit;
  }
}