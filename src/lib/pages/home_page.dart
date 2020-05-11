import 'package:flutter/material.dart';
import 'package:kudosapp/pages/achievements_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
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
              backgroundImage: NetworkImage(authViewModel.currentUser.imageUrl),
            ),
            title: Text(authViewModel.currentUser.name ?? ''),
            subtitle: Text(authViewModel.currentUser.email ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: authViewModel.signOut,
            ),
          ),
          RaisedButton(
            child: Text("navigate to badges_page"),
            onPressed: () {
              Navigator.of(context).push(AchievementsRoute());
            },
          ),
          RaisedButton(
            child: Text("navigate to people_page"),
            onPressed: () {
              Navigator.of(context).push(PeopleRoute());
            },
          ),
          RaisedButton(
            child: Text("navigate to create Achievement"),
            onPressed: () {
              Navigator.of(context).push(EditAchievementRoute(null));
            },
          ),
        ],
      ),
    );
  }
}
