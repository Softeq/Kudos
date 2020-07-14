import 'dart:async';

import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/user_achievement.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/database/achievements_database_service.dart';
import 'package:kudosapp/services/database/database_service.dart';
import 'package:kudosapp/services/image_service.dart';

class AchievementsService {
  final _imageService = locator<ImageService>();
  final _authService = locator<BaseAuthService>();
  final _databaseService = locator<DatabaseService>();
  final _achievementsDatabaseService = locator<AchievementsDatabaseService>();

  Future<List<AchievementModel>> getAchievements() async {
    return _achievementsDatabaseService.getTeamsAchievements().then((list) =>
        list.map((a) => AchievementModel.fromAchievement(a)).toList());
  }

  Future<AchievementModel> createAchievement(
      AchievementModel achievement) async {
    var imageData = await _imageService.uploadImage(achievement.imageFile);
    achievement.imageName = imageData.name;
    achievement.imageUrl = imageData.url;

    return _achievementsDatabaseService
        .createAchievement(Achievement.fromModel(achievement))
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<AchievementModel> updateAchievement(
      AchievementModel achievementModel) async {
    bool uploadImage = false;
    if (achievementModel.imageFile != null) {
      var imageData =
          await _imageService.uploadImage(achievementModel.imageFile);
      achievementModel.imageName = imageData.name;
      achievementModel.imageUrl = imageData.url;
      uploadImage = true;
    }
    // else {
    //   achievementModel.imageName = null;
    //   achievementModel.imageUrl = null;
    // }

    return _achievementsDatabaseService
        .updateAchievement(Achievement.fromModel(achievementModel),
            metadata: true, image: uploadImage)
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<void> sendAchievement(
      UserModel recipient, UserAchievementModel userAcheivementModel) {
    final userAchievement = UserAchievement.fromModel(userAcheivementModel);

    return _databaseService.batchUpdate(
        // add an achievement to user's achievements
        (batch) => _achievementsDatabaseService.createUserAchievement(
            recipient.id, userAchievement, batch: batch),
        // add a user to achievements
        (batch) => _achievementsDatabaseService.createAchievementHolder(
            userAcheivementModel.achievement.id,
            AchievementHolder.fromModel(recipient),
            batch: batch));
  }

  Future<AchievementModel> transferAchievement(
      AchievementModel achievementModel, AchievementOwnerModel newOwner) async {
    var achievement =
        Achievement.fromModel(achievementModel, newOwner: newOwner);

    return _achievementsDatabaseService
        .updateAchievement(achievement, owner: true)
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<void> deleteAchievement(
    AchievementModel achievementModel, {
    int holdersCount,
  }) {
    if (holdersCount != null && holdersCount == 0) {
      return _achievementsDatabaseService
          .deleteAchievement(achievementModel.id);
    } else {
      var achievement =
          Achievement.fromModel(achievementModel, isActive: false);
      return _achievementsDatabaseService.updateAchievement(achievement,
          isActive: true);
    }
  }

  Future<List<UserAchievementModel>> getReceivedAchievements(String userId) {
    return _achievementsDatabaseService.getReceivedAchievements(userId).then(
        (list) => list
            .map((ua) => UserAchievementModel.fromUserAchievement(ua))
            .toList());
  }

  Future<List<UserModel>> getAchievementHolders(String achivementId) async {
    return _achievementsDatabaseService
        .getAchievementHolders(achivementId)
        .then((list) => list
            .toSet()
            .map((h) => UserModel.fromUserReference(h.recipient))
            .toList());
  }

  Future<AchievementModel> getAchievement(String achivementId) async {
    return _achievementsDatabaseService
        .getAchievement(achivementId)
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<List<AchievementModel>> getTeamAchievements(String teamId) async {
    return _achievementsDatabaseService.getTeamAchievements(teamId).then(
        (list) =>
            list.map((a) => AchievementModel.fromAchievement(a)).toList());
  }

  Future<List<AchievementModel>> getMyAchievements() {
    return _achievementsDatabaseService
        .getTeamAchievements(_authService.currentUser.id)
        .then((list) =>
            list.map((a) => AchievementModel.fromAchievement(a)).toList());
  }
}
