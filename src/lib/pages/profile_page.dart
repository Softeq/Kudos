import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/widgets/image_loader.dart';
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
              _buildAchievementsList(viewModel),
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
              backgroundImage: NetworkImage(user.imageUrl),
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

  Widget _buildAchievementsList(ProfileViewModel viewModel) {
    return FutureBuilder<List<Achievement>>(
      future: viewModel.achievements,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _buildLoading();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return _buildError(snapshot.error);
            } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return _buildList(snapshot.data);
            } else {
              return _buildEmpty();
            }
            break;
          case ConnectionState.active:
          case ConnectionState.none:
          default:
            return _buildError("Unknown state");
        }
      },
    );
  }

  Widget _buildLoading() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        "Error: $error", // TODO YP: temporary
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text("No data"), // TODO YP: temporary
    );
  }

  Widget _buildList(List<Achievement> achievements) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) =>
            _buildListItem(context, achievements[index]),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Achievement achievement) {
    return InkWell(
      child: ImageLoader(
        url: achievement.imageUrl,
      ),
      onTap: () {
        Navigator.of(context).push(AchievementDetailsRoute(achievement));
      },
    );
  }
}
