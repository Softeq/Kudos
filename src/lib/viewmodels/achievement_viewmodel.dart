import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/team_reference.dart';
import 'package:kudosapp/models/user_reference.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class AchievementViewModel extends BaseViewModel {
  final _imageViewModel = new ImageViewModel();

  Achievement _initialAchievement;
  String _title;
  String _description;

  AchievementViewModel([Achievement achievement]) {
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
