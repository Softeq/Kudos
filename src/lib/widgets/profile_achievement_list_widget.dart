import 'package:flutter/material.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
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
    return FutureBuilder<List<UserAchievementCollection>>(
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

  Widget _buildList(List<UserAchievementCollection> achievementCollections) {
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
        itemCount: achievementCollections.length,
        itemBuilder: (context, index) => _buildListItem(
          context,
          achievementCollections[index],
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    UserAchievementCollection achievementCollection,
  ) {
    final relatedAchievement =
        achievementCollection.userAchievement.achievement;
    return InkWell(
      child: Stack(
        children: <Widget>[
          ImageLoader(
            url: relatedAchievement.imageUrl,
          ),
          if (achievementCollection.count > 1)
            _buildCountBadge(achievementCollection)
        ],
      ),
      onTap: () async {
        // TODO YP: refactor
        final achievementService = locator<AchievementsService>();
        final achievement =
            await achievementService.getAchievement(relatedAchievement.id);
        Navigator.of(context).push(AchievementDetailsRoute(achievement));
      },
    );
  }

  Widget _buildCountBadge(UserAchievementCollection achievementCollection) {
    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber[900],
          border: Border.all(
            width: 3.0,
            color: Colors.white,
          ),
        ),
        child: Text(
          "x${achievementCollection.count}",
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
