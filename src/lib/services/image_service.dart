import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:kudosapp/core/errors/upload_file_error.dart';
import 'package:kudosapp/models/image_data.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageService {
  static const kudosFolder = "kudos";

  Future<ImageData> uploadImage(File file) async {
    if (file == null) {
      throw ArgumentError.notNull("file");
    }

    final fileExtension = path.extension(file.path);
    final fileName = "${Uuid().v4()}$fileExtension";
    final storageReference =
        FirebaseStorage.instance.ref().child(kudosFolder).child(fileName);
    final storageUploadTask = storageReference.putFile(file);
    final storageTaskSnapshot = await storageUploadTask.onComplete;

    if (storageTaskSnapshot.error != null) {
      throw UploadFileError();
    }

    final imageUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return ImageData(imageUrl, fileName);
  }
}
