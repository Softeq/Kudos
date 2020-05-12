import 'package:file_picker/file_picker.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/achievement_item_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class EditAchievementViewModel extends BaseViewModel {
  AchievementItemViewModel _achievementViewModel;
  bool _isBusy = false;

  AchievementItemViewModel get achievementViewModel => _achievementViewModel;

  bool get isBusy => _isBusy;

  set isBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void initialize(Achievement achievement) {
    _achievementViewModel = AchievementItemViewModel(
      achievement: achievement,
      category: null,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _achievementViewModel.dispose();
    super.dispose();
  }

  void pickFile() async {
    if (achievementViewModel.isFileLoading) {
      return;
    }
    achievementViewModel.isFileLoading = true;

    var file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ["svg, gif"],
    );
    if (file != null) {
      achievementViewModel.file = file;
    } else {
      achievementViewModel.isFileLoading = false;
    }
  }

  Future<void> save() {
    var achievementsService = locator<AchievementsService>();
    var achievement = achievementViewModel.model.copy(
      description: achievementViewModel.description,
      imageUrl: achievementViewModel.imageUrl,
      name: achievementViewModel.title,
    );

    return achievementsService.createOrUpdate(achievement, achievementViewModel.file);
  }
}
