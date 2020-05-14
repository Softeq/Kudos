import 'package:flutter/material.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
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

class _ManageTeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var localizationService = locator<LocalizationService>();
    return Scaffold(
      appBar: AppBar(
        title: Text(localizationService.team),
      ),
      body: Consumer<ManageTeamViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.isInitialized) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var textTheme = Theme.of(context).textTheme;
          return Padding(
            padding: EdgeInsets.only(
              left: 72.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    IconButton(
                      onPressed: () async {
                        var team = viewModel.team;
                        var editedTeam = await Navigator.of(context)
                            .push(EditTeamRoute(team));
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
                  ],
                ),
                SizedBox(height: 24.0),
                Text(
                  localizationService.owner,
                  style: textTheme.caption,
                ),
                SizedBox(height: 6.0),
                Text(viewModel.owners.map((x) => x.name).join(",")),
                SizedBox(height: 24.0),
                Text(
                  localizationService.members,
                  style: textTheme.caption,
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
                            userIds: teamMembers.items
                                .map((x) => x.teamMember.id)
                                .toList(),
                          ),
                        );
                        viewModel.replaceMembers(users);
                      };

                      if (teamMembers.items.isEmpty) {
                        return GestureDetector(
                          child: Text(localizationService.addMembers),
                          onTap: addUsersAction,
                        );
                      }

                      var memberWidgets = teamMembers.items
                          .map((x) => _buildMember(x))
                          .toList();

                      return GestureDetector(
                        child: Wrap(
                          spacing: 8.0,
                          children: memberWidgets,
                        ),
                        onTap: addUsersAction,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMember(TeamMemberViewModel teamMemberViewModel) {
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
