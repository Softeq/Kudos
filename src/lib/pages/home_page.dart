import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/pages/achievements_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/widgets/button.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().appName),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                authViewModel.currentUser.imageUrl,
              ),
            ),
            title: Text(authViewModel.currentUser.name ?? ''),
            subtitle: Text(authViewModel.currentUser.email ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: authViewModel.signOut,
            ),
          ),
          SizedBox(height: 24),
          Button("List of Achievements", () {
              Navigator.of(context).push(AchievementsRoute());
            },
          ),
          SizedBox(height: 24),
          Button("List of Users", () {
              Navigator.of(context).push(PeopleRoute());
            },
          ),
          SizedBox(height: 24),
          Button("Create Achievement", () {
              Navigator.of(context).push(EditAchievementRoute(null));
            },
          ),
        ],
      ),
    );
  }
}
