import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/widgets/image_loader.dart';

class AchievementRoute extends MaterialPageRoute {
  AchievementRoute(Achievement achievement)
    : super(
        builder: (context) {
          return ChangeNotifierProvider<AchievementViewModel>(
            create: (context) => AchievementViewModel(achievement),
            child: AchievementPage(),
          );
        },
      );
}

class AchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.achievement.name),
          ),
          body: _buildBody(viewModel.achievement),
        );
      }
    );
  }

  Widget _buildBody(Achievement achievement) {
    return Column(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Hero(
              child: ImageLoader(achievement.imageUrl),
              tag: achievement.name,
            ),
          ),
        ),
        RaisedButton(
          child: Text("Send"),
          onPressed: () {
            // TODO YP:
          },
        )
      ],
    );
  }
}