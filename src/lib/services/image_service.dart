import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/models/errors/upload_file_error.dart';
import 'package:kudosapp/models/image_data.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/services/file_service.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class ImageService {
  static const kudosFolder = "kudos";

  final _fileService = locator<FileService>();
  final _dialogService = locator<DialogService>();

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

  Future<File> pickImage(BuildContext context) async {
    var file = await FilePicker.getFile(type: FileType.image);
    var isValid = file == null || await _fileService.isFileSizeValid(file);

    if (!isValid) {
      _dialogService.showOkDialog(
          context: context,
          title: localizer().error,
          content: localizer().fileSizeTooBig);
    }

    return isValid ? file : null;
  }
}
