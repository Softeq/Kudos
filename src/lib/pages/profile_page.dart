import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';

class ProfileRoute extends MaterialPageRoute {
  ProfileRoute(User user)
    : super(
        builder: (context) {
          return ChangeNotifierProvider<ProfileViewModel>(
            create: (context) => ProfileViewModel(),
            child: ProfilePage(),
          );
        },
        settings: RouteSettings(
          arguments: user,
        )
      );
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context).settings.arguments as User;

    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().profile),
      ),
      body: Center(
        child: Text("${user.name} profile"), // TODO YP: complete the screen
      ),
    );
  }
}