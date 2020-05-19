import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/pages/teams/user_teams_widget.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProfileViewModel>(
      builder: (context, viewModel, child) {
        final user = viewModel.profile.user;

        return Scaffold(
          appBar: AppBar(
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
                onPressed: viewModel.auth.signOut,
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: UserTeamsWidget(user.id),
                ),
              ),
              ProfileAchievementsList(viewModel.profile),
            ],
          ),
        );
      },
    );
  }
}
