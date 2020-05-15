import 'package:flutter/material.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';
import 'package:provider/provider.dart';

class ManageTeamRoute extends MaterialPageRoute {
  ManageTeamRoute(Team team)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ManageTeamViewModel>(
              create: (context) {
                return ManageTeamViewModel()..initialize(team);
              },
              child: _ManageTeamPage(),
            );
          },
        );
}

class _ManageTeamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ManageTeamPageState();
  }
}

class _ManageTeamPageState extends State<_ManageTeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ManageTeamViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isInitialized) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildTitle(viewModel);
              } else {
                var lineData = viewModel.getData(index);
                return AchievementWidget(lineData, onAchievementTapped);
              }
            },
            itemCount: viewModel.itemsCount,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var viewModel =
              Provider.of<ManageTeamViewModel>(context, listen: false);
          Navigator.of(context).push(EditAchievementRoute(
            team: viewModel.modifiedTeam,
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void onAchievementTapped(AchievementViewModel x) async {
    Navigator.of(context).push(AchievementDetailsRoute(x.achievement));
  }

  Widget _buildTitle(
    ManageTeamViewModel viewModel,
  ) {
    var localizationService = locator<LocalizationService>();
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      viewModel.name,
                      style: textTheme.headline6,
                    ),
                    SizedBox(height: 6.0),
                    Text(
                      viewModel.description,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: IconButton(
                  onPressed: () async {
                    var team = viewModel.modifiedTeam;
                    var editedTeam =
                        await Navigator.of(context).push(EditTeamRoute(team));
                    if (editedTeam != null) {
                      var resultTeam = team.copy(
                        name: editedTeam.name,
                        description: editedTeam.description,
                      );
                      viewModel.initialize(resultTeam);
                    }
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            localizationService.owner,
            style: textTheme.caption,
          ),
        ),
        SizedBox(height: 6.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(viewModel.owners.map((x) => x.name).join(",")),
        ),
        SizedBox(height: 24.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            localizationService.members,
            style: textTheme.caption,
          ),
        ),
        SizedBox(height: 6.0),
        ChangeNotifierProvider<ListNotifier<TeamMemberViewModel>>.value(
          value: viewModel.members,
          child: Consumer<ListNotifier<TeamMemberViewModel>>(
            builder: (context, teamMembers, child) {
              var addUsersAction = () async {
                var users = await Navigator.of(context).push(
                  UserPickerRoute(
                    allowMultipleSelection: true,
                    userIds:
                        teamMembers.items.map((x) => x.teamMember.id).toList(),
                  ),
                );
                viewModel.replaceMembers(users);
              };

              if (teamMembers.items.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    child: Text(localizationService.addPeople),
                    onTap: addUsersAction,
                  ),
                );
              }

              var memberWidgets =
                  teamMembers.items.map((x) => _buildMember(x)).toList();

              return Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  child: Wrap(
                    spacing: 8.0,
                    children: memberWidgets,
                  ),
                  onTap: addUsersAction,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 32.0),
      ],
    );
  }

  static Widget _buildMember(TeamMemberViewModel teamMemberViewModel) {
    var color = teamMemberViewModel.color;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 6.0,
      ),
      margin: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(
          40,
          color.red,
          color.green,
          color.blue,
        ),
        border: Border(
          bottom: BorderSide(
            color: color,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Text(
        teamMemberViewModel.teamMember.name,
      ),
    );
  }
}
