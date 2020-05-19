import 'package:flutter/material.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/achievements_service.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_image_widget.dart';

class ProfileAchievementsList extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileAchievementsList(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserAchievementCollection>>(
      future: viewModel.achievements,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return _buildList(snapshot.data);
        }
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _buildChild(snapshot),
        );
      },
    );
  }

  _buildChild(AsyncSnapshot<List<UserAchievementCollection>> snapshot) {
    if (snapshot.hasData) {
      return _buildEmpty();
    }
    if (snapshot.hasError) {
      return _buildError(snapshot.error);
    }
    return _buildLoading();
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
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
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildListItem(
            context,
            achievementCollections[index],
          ),
          childCount: achievementCollections.length,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        var radius = constraints.maxWidth / 2.0;

        return GestureDetector(
          child: Stack(
            children: <Widget>[
              AchievementImageWidget(
                imageUrl: relatedAchievement.imageUrl,
                radius: radius,
              ),
              if (achievementCollection.count > 1)
                _buildCountBadge(achievementCollection, constraints.maxWidth)
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
      },
    );
  }

  Widget _buildCountBadge(
    UserAchievementCollection achievementCollection,
    double parentWidth,
  ) {
    final count = achievementCollection.count;
    final scale = parentWidth / 4;

    return Positioned(
      bottom: 4,
      right: 4,
      child: Container(
        height: scale,
        padding: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 6,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scale),
          color: Colors.amber[900],
          border: Border.all(
            width: 3.0,
            color: Colors.white,
          ),
        ),
        child: FittedBox(
          child: Text(
            "x$count",
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
