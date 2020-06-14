import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/widgets/achievement_list_widget.dart';

import 'achievement_details_page.dart';

class AchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizer().allAchievements),
      ),
      body: Consumer<AchievementsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return AchievementListWidget.from(
              viewModel.achievements,
              (x) {
                Navigator.of(context).push(
                  AchievementDetailsRoute(x.achievement.id),
                );
              },
            );
          }
        },
      ),
    );
  }
}
