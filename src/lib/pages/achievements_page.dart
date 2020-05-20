import 'package:flutter/material.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_list_widget.dart';
import 'package:provider/provider.dart';

//TODO VPY: remove from main page and rebuild for search achievement screen
class AchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().allAchievements),
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
                  AchievementDetailsRoute(x.achievement),
                );
              },
            );
          }
        },
      ),
    );
  }
}
