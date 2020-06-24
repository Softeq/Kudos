import 'package:flutter/material.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/profile/received_achievement_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile_achievements_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/counter_widget.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class ProfileAchievementsListWidget extends StatelessWidget {
  final String _userId;
  final bool _buildSliver;

  ProfileAchievementsListWidget(this._userId, this._buildSliver);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileAchievementsViewModel>(
      create: (context) {
        return ProfileAchievementsViewModel(_userId)..initialize();
      },
      child: Consumer<ProfileAchievementsViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isBusy && viewModel.achievements.isNotEmpty) {
            return _buildView(
              viewModel.achievements,
              viewModel.isMyProfile,
            );
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
        sprintf(localizer().error, [error]),
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

  Widget _buildView(
    List<UserAchievementCollection> achievementCollections,
    bool isMyProfile,
  ) {
    if (_buildSliver) {
      return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildGridItem(
            context,
            achievementCollections[index],
            isMyProfile,
          ),
          childCount: achievementCollections.length,
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.only(top: TopDecorator.height, bottom: BottomDecorator.height),
      itemCount: achievementCollections.length,
      itemBuilder: (context, index) {
        final achievementCollection = achievementCollections[index];
        final relatedAchievement =
            achievementCollection.userAchievements[0].achievement;

        return SimpleListItem(
          title: relatedAchievement.name,
          description:
              sprintf(localizer().from, [achievementCollection.senders]),
          imageViewModel: achievementCollection.imageViewModel,
          imageCounter: achievementCollection.count,
          onTap: () {
            if (isMyProfile) {
              Navigator.of(context).push(
                ReceivedAchievementRoute(achievementCollection),
              );
            } else {
              Navigator.of(context).push(
                AchievementDetailsRoute(relatedAchievement.id),
              );
            }
          },
          imageShape: ImageShape.circle(60),
        );
      },
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    UserAchievementCollection achievementCollection,
    bool isMyProfile,
  ) {
    final relatedAchievement =
        achievementCollection.userAchievements[0].achievement;
    return LayoutBuilder(
      builder: (context, constraints) {
        final children = <Widget>[
          RoundedImageWidget.circular(
            imageViewModel: achievementCollection.imageViewModel,
            size: constraints.maxWidth,
          ),
        ];

        if (achievementCollection.count > 1) {
          children.add(
            Positioned(
              bottom: 5.0,
              right: 2.0,
              child: CounterWidget(
                  count: achievementCollection.count,
                  height: constraints.maxWidth / 3.0),
            ),
          );
        }

        return GestureDetector(
          child: Stack(
            children: children,
          ),
          onTap: () {
            if (isMyProfile) {
              Navigator.of(context).push(
                ReceivedAchievementRoute(achievementCollection),
              );
            } else {
              Navigator.of(context).push(
                AchievementDetailsRoute(relatedAchievement.id),
              );
            }
          },
        );
      },
    );
  }
}
