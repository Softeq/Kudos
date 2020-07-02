import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/profile/received_achievement_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile_achievements_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/counter_widget.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class ProfileAchievementsListWidget extends StatelessWidget {
  final String _userId;
  final bool _buildSliver;
  final bool _centerMessages;

  ProfileAchievementsListWidget(this._userId, this._buildSliver,
      [bool centerMessages])
      : _centerMessages = centerMessages ?? true;

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
    return _buildError(localizer().generalError);
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(Object error) {
    return _buildMessage(Text(sprintf(localizer().error, [error]),
        style: KudosTheme.errorTextStyle));
  }

  Widget _buildEmpty() {
    return _buildMessage(Text(localizer().profileAchievementsEmptyPlaceholder,
        style: KudosTheme.sectionEmptyTextStyle));
  }

  Widget _buildMessage(Text text) {
    if (_centerMessages) {
      return Center(
        child: text,
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 16),
        child: text,
      );
    }
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

    return GridView.builder(
        padding: EdgeInsets.only(
          top: TopDecorator.height + 10,
          bottom: BottomDecorator.height,
          left: 8,
          right: 8,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 30,
          childAspectRatio: 0.86,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) => _buildGridItem(
              context,
              achievementCollections[index],
              isMyProfile,
            ),
        itemCount: achievementCollections.length);
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
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;

        var children = <Widget>[];

        children.add(
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0,
            start: 0,
            end: 0,
            child: RoundedImageWidget.circular(
              imageUrl: achievementCollection.imageUrl,
              size: width - 5,
              addHeroAnimation: true,
            ),
          ),
        );

        children.add(
          Positioned.fill(
            child: Image(
              image: AssetImage(
                  'assets/icons/medal_cropped_placeholder_blured_white.png'),
              width: width,
              height: height,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
        );

        if (achievementCollection.count > 1) {
          children.add(
            Positioned(
              bottom: 5.0,
              right: 2.0,
              child: CounterWidget(
                  count: achievementCollection.count, height: width / 3.0),
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
                AchievementDetailsRoute(relatedAchievement.id, achievementCollection.imageUrl),
              );
            }
          },
        );
      },
    );
  }
}
