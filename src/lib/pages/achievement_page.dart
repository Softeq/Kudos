import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/sending_page.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/widgets/image_loader.dart';
import 'package:provider/provider.dart';

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
    return Consumer<AchievementViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.achievement.name),
        ),
        body: _buildBody(viewModel, context),
      );
    });
  }

  Widget _buildBody(AchievementViewModel viewModel, BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Hero(
              child: ImageLoader(
                url: viewModel.achievement.imageUrl,
              ),
              tag: viewModel.achievement.name,
            ),
          ),
        ),
        RaisedButton(
          child: Text("Send"),
          onPressed: () {
            Navigator.of(context).push(SendingRoute(viewModel.achievement));
          },
        ),
        RaisedButton(
          child: Text("Edit"),
          onPressed: () {
            Navigator.of(context)
                .push(EditAchievementRoute(viewModel.achievement));
          },
        ),
      ],
    );
  }
}
