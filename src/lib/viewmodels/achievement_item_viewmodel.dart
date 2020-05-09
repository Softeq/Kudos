import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_category.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementItemViewModel extends BaseViewModel {
  String _title;
  String _description;
  String _imageUrl;
  File _file;
  bool _isFileLoading = false;
  Achievement _achievement;

  final AchievementCategory category;

  AchievementItemViewModel({
    @required Achievement achievement,
    @required this.category,
  }) : assert(achievement != null) {
    _achievement = achievement;
    _title = achievement.name;
    _description =
        achievement.description ?? locator<LocalizationService>().testLongText;
    _imageUrl = achievement.imageUrl;
  }

  Achievement get model => _achievement;

  String get title => _title ?? "";

  set title(String value) {
    _title = value;
    notifyListeners();
  }

  String get description => _description ?? "";

  set description(String value) {
    _description = value;
    notifyListeners();
  }

  String get imageUrl => _imageUrl;

  File get file => _file;

  set file(File value) {
    _file = value;
    _isFileLoading = false;
    notifyListeners();
  }

  bool get isFileLoading => _isFileLoading;

  set isFileLoading(bool value) {
    _isFileLoading = value;
    notifyListeners();
  }
}
