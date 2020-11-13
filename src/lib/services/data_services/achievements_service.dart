import 'dart:async';

import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/achievement_holder.dart';
import 'package:kudosapp/dto/user_achievement.dart';
import 'package:kudosapp/models/access_level.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/models/errors/wrong_user_error.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/services/cache/cached_data_service.dart';
import 'package:kudosapp/services/cache/item_change.dart';
import 'package:kudosapp/services/database/achievements_database_service.dart';
import 'package:kudosapp/services/database/database_service.dart';
import 'package:kudosapp/services/database/users_database_service.dart';
import 'package:kudosapp/services/image_service.dart';

class AchievementsService
    extends CachedDataService<Achievement, AchievementModel> {
  static const int InputStreamsCount = 2;

  final _imageService = locator<ImageService>();
  final _authService = locator<BaseAuthService>();
  final _databaseService = locator<DatabaseService>();
  final _usersDatabaseService = locator<UsersDatabaseService>();
  final _achievementsDatabaseService = locator<AchievementsDatabaseService>();

  AchievementsService() : super(InputStreamsCount);

  Future<Iterable<AchievementModel>> getAchievements() async {
    await loadData();
    return cachedData.values;
  }

  Future<Map<String, AchievementModel>> getAchievementsMap() async {
    await loadData();
    return cachedData;
  }

  Future<AchievementModel> getAchievement(String achievementId) async {
    await loadData();

    if (cachedData.containsKey(achievementId)) {
      return cachedData[achievementId];
    }

    return _achievementsDatabaseService
        .getAchievement(achievementId)
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<List<AchievementModel>> getTeamAchievements(String teamId) async {
    await loadData();
    return cachedData.values.where((a) => a.owner.id == teamId).toList();
  }

  Future<List<UserAchievementModel>> getReceivedAchievements(String userId) {
    return _achievementsDatabaseService.getReceivedAchievements(userId).then(
        (list) => list
            .map((ua) => UserAchievementModel.fromUserAchievement(ua))
            .toList());
  }

  Future<List<UserModel>> getAchievementHolders(String achievementId) async {
    return _achievementsDatabaseService
        .getAchievementHolders(achievementId)
        .then((list) => list
            .toSet()
            .map((h) => UserModel.fromUserReference(h.recipient))
            .toList());
  }

  Future<AchievementModel> createAchievement(
    AchievementModel achievement,
  ) async {
    var imageData = await _imageService.uploadImage(achievement.imageFile);
    achievement.imageName = imageData.name;
    achievement.imageUrl = imageData.url;

    return _achievementsDatabaseService
        .createAchievement(Achievement.fromModel(achievement))
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<AchievementModel> updateAchievement(
    AchievementModel achievementModel,
  ) async {
    bool updateImage = false;
    if (achievementModel.imageFile != null) {
      var imageData =
          await _imageService.uploadImage(achievementModel.imageFile);
      achievementModel.imageName = imageData.name;
      achievementModel.imageUrl = imageData.url;
      updateImage = true;
    }

    return _achievementsDatabaseService
        .updateAchievement(
          Achievement.fromModel(achievementModel),
          updateMetadata: true,
          updateImage: updateImage,
        )
        .then((a) => AchievementModel.fromAchievement(a));
  }

  Future<void> sendAchievement(
    UserModel recipient,
    UserAchievementModel userAchievementModel,
  ) {
    final achievement = cachedData[userAchievementModel.achievement.id];
    if (achievement.accessLevel == AccessLevel.private &&
        achievement.teamMembers[recipient.id] == null) {
      throw WrongUserError();
    }

    final userAchievement = UserAchievement.fromModel(userAchievementModel);

    return _databaseService.batchUpdate(
      [
        // add an achievement to user's achievements
        (batch) => _achievementsDatabaseService.createUserAchievement(
              recipient.id,
              userAchievement,
              batch: batch,
            ),
        // TODO YP: move to cloud functions:
        // add a user to achievements
        (batch) => _achievementsDatabaseService.createAchievementHolder(
              userAchievementModel.achievement.id,
              AchievementHolder.fromModel(recipient),
              batch: batch,
            ),
        // increment received_achievements_count
        (batch) => _usersDatabaseService.incrementRecievedAchievementsCount(
              recipient.id,
              batch: batch,
            ),
      ],
    );
  }

  Future<AchievementModel> transferAchievement(
    AchievementModel achievementModel,
    AchievementOwnerModel newOwner,
  ) async {
    var achievement = Achievement.fromModel(
      achievementModel,
      newOwner: newOwner,
    );

    return _achievementsDatabaseService
        .updateAchievement(
          achievement,
          updateOwner: true,
        )
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
      var achievement = Achievement.fromModel(
        achievementModel,
        isActive: false,
      );
      return _achievementsDatabaseService.updateAchievement(
        achievement,
        updateIsActive: true,
      );
    }
  }

  Future<void> markCurrentUserAchievementAsViewed(
    AchievementModel achievement,
  ) {
    return _achievementsDatabaseService.markUserAchievementAsViewed(
      _authService.currentUser.id,
      achievement.id,
    );
  }

  @override
  AchievementModel convert(Achievement item) =>
      AchievementModel.fromAchievement(item);

  @override
  Future<Iterable<Achievement>> getDataFromInputStream(int index) {
    switch (index) {
      // My teams achievements
      case 0:
        return _achievementsDatabaseService.getUserTeamsAchievements(
          _authService.currentUser.id,
        );
      // Accessible achievements (public and protected)
      case 1:
        return _achievementsDatabaseService.getAccessibleAchievements();
      default:
        throw ("Index out of range");
    }
  }

  @override
  String getItemId(AchievementModel item) => item.id;

  @override
  Stream<Iterable<ItemChange<Achievement>>> getInputStream(int index) {
    switch (index) {
      // My teams achievements
      case 0:
        return _achievementsDatabaseService.getUserTeamsAchievementsStream(
          _authService.currentUser.id,
        );
      // Accessible achievements (public and protected)
      case 1:
        return _achievementsDatabaseService.getAccessibleAchievementsStream();
      default:
        throw ("Index out of range");
    }
  }
}
