import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/common/fancy_list_widget.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
import 'package:kudosapp/widgets/sliver_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class ProfileRoute extends MaterialPageRoute {
  ProfileRoute(String userId, String userName, String imageUrl)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ProfileViewModel>(
              create: (context) =>
                  ProfileViewModel(userId, userName, imageUrl)..initialize(),
              child: ProfilePage(),
            );
          },
        );
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: _buildSlivers(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _addDefaultSliverPadding(Widget widget) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16, right: 16),
      sliver: widget,
    );
  }

  List<Widget> _buildSlivers(BuildContext context, ProfileViewModel viewModel) {
    List<Widget> result = [
      SliverGradientAppBar(
        title: viewModel.userName,
        imageWidget: _buildAppBarImage(context, viewModel.imageUrl),
        heroTag: viewModel.imageUrl,
      ),
    ];

    if (viewModel.user == null) {
      result.add(SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    } else {
      result.add(_addDefaultSliverPadding(
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              SectionHeaderWidget(localizer().teams),
              SizedBox(height: 10),
              FancyListWidget<Team>(
                viewModel.userTeams,
                (team) => team.name,
                localizer().userTeamsEmptyPlaceholder,
              ),
              SizedBox(height: 30),
              SectionHeaderWidget(localizer().achievements),
              SizedBox(height: 10),
            ],
          ),
        ),
      ));
      result.add(_addDefaultSliverPadding(
        ProfileAchievementsListWidget(viewModel.user.id, true, false),
      ));
    }
    return result;
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
}
