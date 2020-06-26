import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/common/fancy_list_widget.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
import 'package:kudosapp/widgets/sliver_gradient_app_bar.dart';
import 'package:provider/provider.dart';

class ProfileRoute extends MaterialPageRoute {
  ProfileRoute(String userId)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ProfileViewModel>(
              create: (context) => ProfileViewModel(userId)..initialize(),
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
    if (viewModel.user == null) {
      return [
        SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ];
    }

    return [
      SliverGradientAppBar(
          title: viewModel.user.name,
          imageWidget: _buildAppBarImage(viewModel.user.imageUrl)),
      _addDefaultSliverPadding(
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              SectionHeaderWidget(localizer().teams),
              SizedBox(height: 10),
              FancyListWidget<Team>(
                viewModel.userTeams,
                (Team team) => team.name,
                localizer().userTeamsEmptyPlaceholder,
              ),
              SizedBox(height: 30),
              SectionHeaderWidget(localizer().allAchievements),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      _addDefaultSliverPadding(
        ProfileAchievementsListWidget(viewModel.user.id, true, false),
      ),
    ];
  }

  Widget _buildAppBarImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
