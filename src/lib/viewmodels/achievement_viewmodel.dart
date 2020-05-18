import 'dart:io';

import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class AchievementViewModel extends BaseViewModel {
  String _teamName;
  Achievement _initialAchievement;

  String _title;
  String _description;
  File _file;
  bool _isFileLoading = false;
  String _teamId;
  String _userId;

  AchievementViewModel(Achievement achievement) {
    initialize(achievement);
  }

  Achievement get achievement => _initialAchievement;

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

  String get imageUrl => _initialAchievement.imageUrl;

  File get file => _file;

  set file(File value) {
    _file = value;
    notifyListeners();
  }

  bool get isFileLoading => _isFileLoading;

  set isFileLoading(bool value) {
    _isFileLoading = value;
    notifyListeners();
  }

  String get teamId => _teamId;
  String get userId => _userId;
  String get teamName => _teamName;

  Achievement getModifiedAchievement() {
    return _initialAchievement.copy(
      name: title,
      description: description,
    );
  }

  void initialize(Achievement achievement) {
    if (achievement == null) {
      return;
    }

    _initialAchievement = achievement;
    _title = achievement.name;
    _description = achievement.description;
    _isFileLoading = false;
    _file = null;
    _teamId = achievement.teamId;
    _userId = achievement.userId;

    if (achievement.teamReference != null) {
      _teamName = achievement.teamReference.name;
    }
  }
}
