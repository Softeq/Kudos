import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/user.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/teams/user_teams_widget.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/sliver_section_header_widget.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProfileViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: _buildAppBar(viewModel),
          body: CustomScrollView(
            slivers: _buildSlivers(viewModel.user),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(MyProfileViewModel viewModel) {
    final user = viewModel.user;
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            user.imageUrl,
          ),
        ),
      ),
      centerTitle: true,
      title: Column(
        children: <Widget>[
          Text(user.name),
          Text(
            user.email,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: viewModel.signOut,
        ),
      ],
    );
  }

  List<Widget> _buildSlivers(User user) {
    return [
      SliverToBoxAdapter(
        child: SizedBox(height: 20),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: UserTeamsWidget(user.id),
        ),
      ),
      SliverSectionHeaderWidget(
        title: locator<LocalizationService>().allAchievements,
      ),
      ProfileAchievementsListWidget(user.id),
    ];
  }
}
