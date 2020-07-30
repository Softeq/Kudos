import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
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
  final bool _centerMessages;

  ProfileAchievementsListWidget(this._userId, this._buildSliver,
      [bool centerMessages])
      : _centerMessages = centerMessages ?? true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileAchievementsViewModel>(
      create: (context) {
        return ProfileAchievementsViewModel(_userId);
      },
      child: Consumer<ProfileAchievementsViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isBusy && viewModel.hasAchievements) {
            return _buildView(viewModel);
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
    if (!viewModel.hasAchievements) {
      return _buildEmpty();
    }
    return _buildError(localizer().generalErrorMessage);
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(Object error) {
    return _buildMessage(Text(sprintf(localizer().detailedError, [error]),
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

  Widget _buildList(
    List<UserAchievementCollection> achievementCollections,
    ProfileAchievementsViewModel viewModel,
  ) {
    return ListView.builder(
      padding: EdgeInsets.only(
          top: TopDecorator.height, bottom: BottomDecorator.height),
      itemCount: achievementCollections.length,
      itemBuilder: (context, index) {
        final achievementCollection = achievementCollections[index];
        final relatedAchievement = achievementCollection.relatedAchievement;

        return SimpleListItem(
          title: relatedAchievement.name,
          description: sprintf(
            localizer().from,
            [achievementCollection.senders],
          ),
          imageUrl: achievementCollection.imageUrl,
          imageCounter: achievementCollection.count,
          onTap: () => viewModel.openAchievementDetails(
            context,
            achievementCollection,
          ),
          imageShape: ImageShape.circle(60),
          addHeroAnimation: true,
        );
      },
    );
  }

  Widget _buildView(ProfileAchievementsViewModel viewModel) {
    final userAcihevements = viewModel.getAchievements();
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
            userAcihevements[index],
            viewModel,
          ),
          childCount: userAcihevements.length,
        ),
      );
    }

    return _buildList(userAcihevements, viewModel);
  }

  Widget _buildGridItem(
    BuildContext context,
    UserAchievementCollection achievementCollection,
    ProfileAchievementsViewModel viewModel,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final children = <Widget>[];

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

        if (achievementCollection.count > 1) {
          children.add(
            Positioned(
              bottom: 5.0,
              right: 2.0,
              child: CounterWidget(
                count: achievementCollection.count,
                height: width / 3.0,
              ),
            ),
          );
        }

        return GestureDetector(
          child: Stack(
            children: children,
          ),
          onTap: () => viewModel.openAchievementDetails(
            context,
            achievementCollection,
          ),
        );
      },
    );
  }
}
