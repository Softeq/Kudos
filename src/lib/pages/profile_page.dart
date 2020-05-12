import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
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
              create: (context) => ProfileViewModel(user),
              child: ProfilePage(),
            );
          },
        );
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().profile),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: <Widget>[
              _buildHeader(context, viewModel.user),
              ProfileAchievementsList(viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, User user) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 80,
            width: 80,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(user.imageUrl),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: <Widget>[
              Text(
                user.name,
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
