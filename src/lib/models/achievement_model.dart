import 'package:flutter/widgets.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/team_reference.dart';
import 'package:kudosapp/dto/user_reference.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class AchievementModel extends ChangeNotifier {
  final _imageViewModel = ImageViewModel();

  Achievement _initialAchievement;
  String _title;
  String _description;

  AchievementModel([Achievement achievement]) {
    if (achievement != null) {
      initialize(achievement);
    }
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

  ImageViewModel get imageViewModel => _imageViewModel;

  TeamReference get team => _initialAchievement?.teamReference;

  UserReference get user => _initialAchievement?.userReference;

  void initialize(Achievement achievement) {
    _initialAchievement = achievement;
    _title = achievement.name;
    _description = achievement.description;

    _imageViewModel.initialize(achievement.imageUrl, null, false);
  }

  @override
  void dispose() {
    _imageViewModel.dispose();
    super.dispose();
  }
}
