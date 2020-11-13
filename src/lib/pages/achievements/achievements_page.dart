import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/achievement_list_item_widget.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/groupped_list_widget.dart';
import 'package:provider/provider.dart';

class AchievementsPage extends StatelessWidget {
  final Widget _content;

  AchievementsPage() : _content = _AchievementsContentPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GradientAppBar(
          title: localizer().achievements,
          elevation: 0,
        ),
        body: _content,
      ),
    );
  }
}

class AchievementsTab extends StatelessWidget {
  final Widget _content;

  AchievementsTab() : _content = _AchievementsContentPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTopBar(context),
        Expanded(
          child: _content,
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 56,
      child: Center(
        child: Text(
          localizer().achievements,
          textAlign: TextAlign.center,
          style: KudosTheme.appBarTitleTextStyle,
        ),
      ),
    );
  }
}

class _AchievementsContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TopDecorator.buildLayoutWithDecorator(
      Container(
        color: KudosTheme.contentColor,
        child: Consumer<AchievementsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isBusy) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: Consumer<AchievementsViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.achievements.isEmpty) {
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

                        return GrouppedListWidget<AchievementModel>(
                          viewModel.achievements,
                          (a) => _buildListItem(
                            viewModel,
                            a,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.ltr,
                    end: 16.0,
                    bottom: 32.0,
                    child: Visibility(
                      visible: viewModel.showAddButton,
                      child: FloatingActionButton(
                        onPressed: () => viewModel.createAchievement(),
                        child: KudosTheme.addIcon,
                      ),
                    ),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListItem(
    AchievementsViewModel viewModel,
    AchievementModel item,
  ) {
    return AchievementListItemWidget(
      item,
      (achievement) => viewModel.onAchievementClicked(achievement),
      viewModel.selectorIcon,
    );
  }
}
