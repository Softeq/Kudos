import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/viewmodels/profile_achievements_viewodel.dart';
import 'package:kudosapp/widgets/achievement_image_widget.dart';

class ProfileAchievementsListWidget extends StatelessWidget {
  final String _userId;
  final bool _buildSliver;

  const ProfileAchievementsListWidget(this._userId, this._buildSliver);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileAchievementsViewModel>(
      create: (context) {
        return ProfileAchievementsViewModel(_userId)..initialize();
      },
      child: Consumer<ProfileAchievementsViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isBusy && viewModel.achievements.isNotEmpty) {
            return _buildGridView(viewModel.achievements);
          }
          return _buildAdaptiveChild(viewModel);
        },
      ),
    );
  }

  Widget _buildAdaptiveChild(ProfileAchievementsViewModel viewModel) {
    if (_buildSliver) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: _buildChild(viewModel),
      );
    }
    return _buildChild(viewModel);
  }

  Widget _buildChild(ProfileAchievementsViewModel viewModel) {
    if (viewModel.isBusy) {
      return _buildLoading();
    }
    if (viewModel.achievements.isEmpty) {
      return _buildEmpty();
    }
    return _buildError("Something went wrong");
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
      child: Text(
        localizer().profileAchievementsEmptyPlaceholder,
      ),
    );
  }

  Widget _buildGridView(List<UserAchievementCollection> achievementCollections) {
    return _buildAdaptiveGridView(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
      ),
      itemCount: achievementCollections.length,
      itemBuilder: (context, index) => _buildListItem(
        context,
        achievementCollections[index],
      ),
    );
  }

  Widget _buildAdaptiveGridView({
    @required EdgeInsets padding,
    @required SliverGridDelegate gridDelegate,
    @required int itemCount,
    @required Widget Function(BuildContext, int) itemBuilder,
  }) {
    if (_buildSliver) {
      return SliverPadding(
        padding: padding,
        sliver: SliverGrid(
          gridDelegate: gridDelegate,
          delegate: SliverChildBuilderDelegate(
            itemBuilder,
            childCount: itemCount,
          ),
        ),
      );
    }
    return GridView.builder(
      padding: padding,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
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
          onTap: () {
            Navigator.of(context).push(
              AchievementDetailsRoute(relatedAchievement.id),
            );
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
