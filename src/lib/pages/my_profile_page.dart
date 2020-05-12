import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProfileViewModel>(
      builder: (context, viewModel, child) {
        final currentUser = viewModel.auth.currentUser;

        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  currentUser.imageUrl,
                ),
              ),
              title: Text(currentUser.name ?? ''),
              subtitle: Text(currentUser.email ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: viewModel.auth.signOut,
              ),
            ),
            ProfileAchievementsList(viewModel.profile),
          ],
        );
      },
    );
  }
}
