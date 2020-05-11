import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/sending_page.dart';
import 'package:kudosapp/viewmodels/achievement_details_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';
import 'package:kudosapp/widgets/button.dart';
import 'package:provider/provider.dart';

class AchievementDetailsRoute extends MaterialPageRoute {
  AchievementDetailsRoute(Achievement achievement)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<AchievementDetailsViewModel>(
              create: (context) {
                return AchievementDetailsViewModel()
                  ..initialize(achievement);
              },
              child: AchievementDetailsPage(),
            );
          },
        );
}

class AchievementDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementDetailsViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.achievementViewModel.title),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: () => Navigator.of(context).push(EditAchievementRoute(viewModel.achievementViewModel.model))
        ),
        body: _buildBody(viewModel, context),
      );
    });
  }

  Widget _buildBody(AchievementDetailsViewModel viewModel, BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            AchievementWidget([viewModel.achievementViewModel]),
            SizedBox(height: 24),
            Button("Send achievement", () {
              Navigator.of(context).push(SendingRoute(viewModel.achievementViewModel.model));
            }),
            SizedBox(height: 24),
            _PopularityWidget(viewModel.statisticsValue),
            _AchievementPeopleWidget()
          ],
        ));
  }
}

class _PopularityWidget extends StatelessWidget {
  final double _popularityPercent;

  _PopularityWidget(this._popularityPercent);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Popularity",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.normal)),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 16,
                width: 144,
                child: LinearProgressIndicator(
                  value: _popularityPercent, // percent filled
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.lightBlueAccent,
                ),
              ),
            )
          ],
        ));
  }
}

class _AchievementPeopleWidget extends StatelessWidget {
  _AchievementPeopleWidget();

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
