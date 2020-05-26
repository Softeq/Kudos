import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/team_reference.dart';
import 'package:kudosapp/models/user_reference.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class AchievementViewModel extends BaseViewModel {
  Achievement _initialAchievement;
  String _title;
  String _description;
  ImageViewModel _imageViewModel;

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

  ImageViewModel get imageViewModel => _imageViewModel;

  TeamReference get team => _initialAchievement.teamReference;

  UserReference get user => _initialAchievement.userReference;

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

    if (_imageViewModel == null) {
      _imageViewModel = ImageViewModel();
    }

    _imageViewModel.initialize(achievement.imageUrl, null, false);
  }

  @override
  void dispose() {
    _imageViewModel.dispose();
    super.dispose();
  }
}
