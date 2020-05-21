import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_profile_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_list_widget.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<MyProfileViewModel>(context, listen: false);
    var user = viewModel.user;
    var localizationService = locator<LocalizationService>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                user.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
          leading: Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  user.imageUrl,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: viewModel.signOut,
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: localizationService.achievements),
              Tab(text: localizationService.teams),
              Tab(text: localizationService.owner),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ProfileAchievementsListWidget(user.id, false),
            ChangeNotifierProvider<MyTeamsViewModel>.value(
              value: viewModel.myTeamsViewModel..initialize(),
              child: _MyTeamsWidget(),
            ),
            ChangeNotifierProvider<MyAchievementsViewModel>.value(
              value: viewModel.myAchievementsViewModel..initialize(),
              child: _MyAchievementsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyAchievementsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAchievementsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          body: ChangeNotifierProvider.value(
            value: viewModel.items,
            child: Consumer<ListNotifier<AchievementViewModel>>(
              builder: (context, notifier, child) {
                if (notifier.items.isEmpty) {
                  return Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Text(
                        locator<LocalizationService>()
                            .createYourOwnAchievements,
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                EditAchievementRoute(
                  user: viewModel.currentUser,
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class _MyTeamsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MyTeamsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.items.isEmpty) {
            return Center(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                child: Text(
                  locator<LocalizationService>().createYourOwnTeams,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: viewModel.items.length,
            itemBuilder: (context, index) {
              var item = viewModel.items[index];
              return ListTile(
                title: Text(item.name),
                onTap: () async {
                  Navigator.of(context).push(ManageTeamRoute(item.id));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(EditTeamRoute());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
