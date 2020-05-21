import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kudosapp/generated/locale_keys.g.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_list_widget.dart';

class AchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.allAchievements.tr()),
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
