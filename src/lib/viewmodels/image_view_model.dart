import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageViewModel extends ChangeNotifier {
  String _imageUrl;
  File _file;
  bool _isBusy;

  String get imageUrl => _imageUrl;

  File get file => _file;

  bool get isBusy => _isBusy;

  void initialize(String imageUrl, File file, bool isBusy) {
    _imageUrl = imageUrl;
    _file = file;
    _isBusy = isBusy;

    notifyListeners();
  }

  void update({String imageUrl, File file, bool isBusy}) {
    if (imageUrl != null) {
      _imageUrl = imageUrl;
    }

    if (file != null) {
      _file = file;
    }

    if (isBusy != null) {
      _isBusy = isBusy;
    }

    notifyListeners();
  }

  Future<void> loadImageFileIfNeeded() async {
    if (imageUrl != null && file == null) {
      var newFile = await DefaultCacheManager().getSingleFile(imageUrl);
      if (newFile != null) {
        _file = newFile;
        notifyListeners();
      }
    }
  }
}
