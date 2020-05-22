import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/fancy_list_widget.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';

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

  Widget _addDefaultSliverPadding(Widget widget,
      [bool addBottomPadding = false]) {
    return SliverPadding(
        padding: EdgeInsets.only(
            left: 16, right: 16, bottom: addBottomPadding ? 16 : 0),
        sliver: widget);
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
      _buildHeader(viewModel.user),
      SliverToBoxAdapter(child: SizedBox(height: 16)),
      _addDefaultSliverPadding(
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SectionHeaderWidget(localizer().teams),
              FancyListWidget<Team>(
                viewModel.userTeams,
                (Team team) => team.name,
                localizer().userTeamsEmptyPlaceholder,
              ),
            ],
          ),
        ),
        true,
      ),
      _addDefaultSliverPadding(
        SliverToBoxAdapter(
          child: SectionHeaderWidget(localizer().allAchievements),
        ),
        true,
      ),
      _addDefaultSliverPadding(
        ProfileAchievementsListWidget(
          viewModel.user.id,
          true,
        ),
      ),
    ];
  }

  Widget _buildHeader(User user) {
    return SliverAppBar(
      expandedHeight: 350.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(user.name),
        background: _buildHeaderBackground(user.imageUrl),
      ),
    );
  }

  Widget _buildHeaderBackground(String imageUrl) {
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
