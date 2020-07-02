import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:kudosapp/helpers/disposable.dart';

class ImageViewModel extends ChangeNotifier with Disposable {
  String _imageUrl;
  File _file;
  bool _isBusy = false;

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
}