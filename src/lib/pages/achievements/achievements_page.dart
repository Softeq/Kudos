import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/achievement_list_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: localizer().allAchievements),
      body: Consumer<AchievementsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
                color: KudosTheme.contentColor,
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: ChangeNotifierProvider.value(
                      value: viewModel.achievements,
                      child: Consumer<ListNotifier<AchievementModel>>(
                        builder: (context, notifier, child) {
                          if (notifier.isEmpty) {
                            return Center(
                              child: FractionallySizedBox(
                                widthFactor: 0.7,
                                child: Text(
                                  localizer().createYourOwnAchievements,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }

                          return AchievementListWidget.from(
                            notifier.items,
                            (x) {
                              Navigator.of(context).push(
                                AchievementDetailsRoute(x.achievement.id),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.ltr,
                    end: 16.0,
                    bottom: 32.0,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          EditAchievementRoute.createUserAchievement(
                            viewModel.currentUser,
                          ),
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  )
                ]));
          }
        },
      ),
    );
  }
}
