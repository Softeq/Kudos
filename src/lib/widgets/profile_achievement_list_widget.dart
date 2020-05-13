import 'package:flutter/material.dart';
import 'package:kudosapp/models/user_achievement.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';
import 'package:kudosapp/widgets/image_loader.dart';

class ProfileAchievementsList extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileAchievementsList(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserAchievement>>(
      future: viewModel.achievements,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoading();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return _buildError(snapshot.error);
            } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return _buildList(snapshot.data);
            } else {
              return _buildEmpty();
            }
            break;
          case ConnectionState.active:
          case ConnectionState.none:
          default:
            return _buildError("Unknown state");
        }
      },
    );
  }

  Widget _buildLoading() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        "Error: $error", // TODO YP: temporary
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text("No data"), // TODO YP: temporary
    );
  }

  Widget _buildList(List<UserAchievement> achievements) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, achievements[index]),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, UserAchievement userAchievement) {
    return InkWell(
      child: ImageLoader(
        url: userAchievement.achievement.imageUrl,
      ),
      onTap: () async {

        // TODO YP: refactor
        final achievementService = locator<AchievementsService>();
        final achievement = await achievementService.getAchievement(userAchievement.achievement.id);
        Navigator.of(context).push(AchievementDetailsRoute(achievement));

      },
    );
  }
}
