import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/user_achievement_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/users/received_achievement_viewmodel.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:kudosapp/widgets/sliver_gradient_app_bar.dart';
import 'package:provider/provider.dart';

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
    BuildContext context,
    ReceivedAchievementViewModel viewModel,
  ) {
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
    BuildContext context,
    ReceivedAchievementViewModel viewModel,
  ) {
    return SliverGradientAppBar(
      context: context,
      heroTag: viewModel.achievementCollection.imageUrl,
      title: viewModel.relatedAchievement.name,
      imageUrl: viewModel.achievementCollection.imageUrl,
      actions: [
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () => viewModel.openAchievementDetails(context),
        )
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    ReceivedAchievementViewModel viewModel,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 20),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: viewModel.achievementCollection.count,
      itemBuilder: (context, index) {
        return _buildUserAchievementView(
          context,
          viewModel.achievementCollection.userAchievements[index],
          (ua) => viewModel.onUserAchievementClicked(ua),
        );
      },
    );
  }

  Widget _buildUserAchievementView(
    BuildContext context,
    UserAchievementModel userAchievementModel,
    void Function(UserAchievementModel) onItemClicked,
  ) {
    return SimpleListItem(
      imageShape: ImageShape.circle(56),
      imageUrl: userAchievementModel.sender.imageUrl,
      title: userAchievementModel.sender.name,
      description: DateFormat.yMd().add_jm().format(userAchievementModel.date),
      contentWidget: _buildCommentView(userAchievementModel.comment),
      onTap: () => onItemClicked?.call(userAchievementModel),
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
