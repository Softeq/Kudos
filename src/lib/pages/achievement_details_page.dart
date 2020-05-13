import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/sending_page.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievement_details_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_horizontal_widget.dart';
import 'package:provider/provider.dart';

import '../service_locator.dart';

class AchievementDetailsRoute extends MaterialPageRoute {
  AchievementDetailsRoute(Achievement achievement)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<AchievementDetailsViewModel>(
              create: (context) {
                return AchievementDetailsViewModel()..initialize(achievement);
              },
              child: AchievementDetailsPage(),
            );
          },
        );
}

class AchievementDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementDetailsViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(viewModel.achievementViewModel.title),
          ),
          body: _buildBodyWithFloatingButtons(viewModel, context));
    });
  }

  Widget _buildBodyWithFloatingButtons(
      AchievementDetailsViewModel viewModel, BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: _buildBody(viewModel, context)),
            Align(
                alignment: Alignment.bottomCenter,
                child: _floatingButtons(viewModel, context)),
          ],
        ));
  }

  Widget _floatingButtons(
      AchievementDetailsViewModel viewModel, BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.send),
              onPressed: () => Navigator.of(context)
                  .push(SendingRoute(viewModel.achievementViewModel.model))),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).push(
                  EditAchievementRoute(viewModel.achievementViewModel.model))),
        ),
      ],
    );
  }

  Widget _buildBody(
      AchievementDetailsViewModel viewModel, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            margin: EdgeInsets.all(8.0),
            height: 140,
            child:
                AchievementHorizontalWidget((viewModel.achievementViewModel))),
        SizedBox(height: 24),
        _PopularityWidget(viewModel.statisticsValue),
        _AchievementPeopleWidget()
      ],
    );
  }
}

class _PopularityWidget extends StatelessWidget {
  final double _popularityPercent;

  _PopularityWidget(this._popularityPercent);

  @override
  Widget build(BuildContext context) {
    var localizationService = locator<LocalizationService>();
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(localizationService.achivementStatisticsTitle,
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
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
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
    return Container(); //PeopleList(null, Icon(Icons.navigate_next));
  }
}
