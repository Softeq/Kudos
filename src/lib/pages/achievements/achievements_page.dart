import 'package:flutter/material.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/achievement_list_widget.dart';
import 'package:provider/provider.dart';

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
