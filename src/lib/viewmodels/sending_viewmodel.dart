import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';

class SendingViewModel extends BaseViewModel {
  final AchievementsService _achievementsService =
      locator<AchievementsService>();
  final BaseAuthService _authService = locator<BaseAuthService>();
  final Achievement achievement;

  SendingViewModel(this.achievement);

  Future<void> sendTo(User recipient, String comment) async {
    final userAchievement = UserAchievement(
      sender: _authService.currentUser,
      recipient: recipient,
      achievement: achievement,
      comment: comment,
    );
    await _achievementsService.sendAchievement(userAchievement);
  }
}
