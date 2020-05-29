import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kudosapp/core/errors/upload_file_error.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageData
{
  final String url;
  final String name;

  ImageData(this.url, this.name);
}

class ImageUploader
{
  static const kudosFolder = "kudos";

  static Future<ImageData> uploadImage(File file) async {
    if (file != null) {
      final fileExtension = path.extension(file.path);
      final fileName = "${Uuid().v4()}$fileExtension";
      final storageReference =
          FirebaseStorage.instance.ref().child(kudosFolder).child(fileName);
      final storageUploadTask = storageReference.putFile(file);
      final storageTaskSnapshot = await storageUploadTask.onComplete;

      if (storageTaskSnapshot.error != null) {
        throw UploadFileError();
      }
      return ImageData(await storageTaskSnapshot.ref.getDownloadURL(), fileName);
    }
    throw UploadFileError();
  }
}