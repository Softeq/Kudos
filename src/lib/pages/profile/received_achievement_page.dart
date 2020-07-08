import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/user_achievement_collection.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/received_achievement_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:kudosapp/widgets/sliver_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class ReceivedAchievementRoute extends MaterialPageRoute {
  ReceivedAchievementRoute(UserAchievementCollection achievementCollection)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ReceivedAchievementViewModel>(
              create: (context) {
                return ReceivedAchievementViewModel(achievementCollection);
              },
              child: ReceivedAchievementPage(),
            );
          },
        );
}

class ReceivedAchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ReceivedAchievementViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: _buildSlivers(context, viewModel),
          );
        },
      ),
    );
  }

  List<Widget> _buildSlivers(
      BuildContext context, ReceivedAchievementViewModel viewModel) {
    Widget bottomArea;
    if (viewModel.isBusy) {
      bottomArea = SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      bottomArea = SliverToBoxAdapter(
        child: _buildBody(context, viewModel),
      );
    }

    return [
      _buildAppBar(context, viewModel),
      bottomArea,
    ];
  }

  Widget _buildAppBar(
      BuildContext context, ReceivedAchievementViewModel viewModel) {
    return SliverGradientAppBar(
        heroTag: viewModel.achievementCollection.imageUrl,
        title: viewModel.relatedAchievement.name,
        imageWidget: _buildAppBarImage(
          context,
          viewModel.achievementCollection.imageUrl,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                AchievementDetailsRoute(viewModel.relatedAchievement),
              );
            },
          )
        ]);
  }

  Widget _buildAppBarImage(BuildContext context, String imageUrl) {
    return Center(
      child: RoundedImageWidget.square(
        imageUrl: imageUrl,
        size: MediaQuery.of(context).size.width,
        borderRadius: 0,
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, ReceivedAchievementViewModel viewModel) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: viewModel.achievementCollection.count,
      itemBuilder: (context, index) {
        return _buildUserAchievementView(
          context,
          viewModel.achievementCollection.userAchievements[index],
        );
      },
    );
  }

  Widget _buildUserAchievementView(
      BuildContext context, UserAchievementModel userAchievementModel) {
    return SimpleListItem(
      imageShape: ImageShape.circle(56),
      imageUrl: userAchievementModel.sender.imageUrl,
      title: userAchievementModel.sender.name,
      description: DateFormat.yMd().add_jm().format(userAchievementModel.date),
      contentWidget: _buildCommentView(userAchievementModel.comment),
      onTap: () {
        Navigator.of(context).push(ProfileRoute(userAchievementModel.sender));
      },
      useTextPlaceholder: true,
    );
  }

  Widget _buildCommentView(String comment) {
    return Align(
      alignment: Alignment.centerLeft,
      child: comment.isNotEmpty
          ? Text(comment, style: KudosTheme.listContentTextStyle)
          : Text(
              localizer().noComment,
              style: KudosTheme.listEmptyContentTextStyle,
            ),
    );
  }
}
