import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kudosapp/generated/locale_keys.g.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';

class ManageTeamRoute extends MaterialPageRoute {
  ManageTeamRoute(String teamId)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<ManageTeamViewModel>(
              create: (context) {
                return ManageTeamViewModel()..initialize(teamId);
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
                return AchievementWidget(lineData, _achievementTapped);
              }
            },
            itemCount: viewModel.itemsCount,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createAchievementTapped,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTitle(
    ManageTeamViewModel viewModel,
  ) {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 4.0,
              top: 4.0,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 8.0),
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
                  onPressed: _editTeamTapped,
                  icon: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.0),
        GestureDetector(
          onTap: _adminsTapped,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LocaleKeys.admins.tr(),
                  style: textTheme.caption,
                ),
                SizedBox(height: 6.0),
                ChangeNotifierProvider<ListNotifier<TeamMember>>.value(
                  value: viewModel.admins,
                  child: Consumer<ListNotifier<TeamMember>>(
                    builder: (context, items, child) {
                      return Text(viewModel.owners);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.0),
        GestureDetector(
          onTap: _membersTapped,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  LocaleKeys.members.tr(),
                  style: textTheme.caption,
                ),
                SizedBox(height: 6.0),
                ChangeNotifierProvider<ListNotifier<TeamMemberViewModel>>.value(
                  value: viewModel.members,
                  child: Consumer<ListNotifier<TeamMemberViewModel>>(
                    builder: (context, teamMembers, child) {
                      if (teamMembers.items.isEmpty) {
                        return Text(LocaleKeys.addPeople.tr());
                      } else {
                        var memberWidgets = teamMembers.items
                            .map((x) => _buildMember(x))
                            .toList();
                        return Wrap(
                          spacing: 8.0,
                          children: memberWidgets,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
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

  void _createAchievementTapped() {
    var viewModel = _getViewModel();
    Navigator.of(context).push(EditAchievementRoute(
      team: viewModel.modifiedTeam,
    ));
  }

  void _achievementTapped(AchievementViewModel x) {
    Navigator.of(context).push(AchievementDetailsRoute(x.achievement.id));
  }

  Future<void> _editTeamTapped() async {
    var viewModel = _getViewModel();
    var team =
        await Navigator.of(context).push(EditTeamRoute(viewModel.modifiedTeam));
    if (team != null) {
      viewModel.initializeWithTeam(team);
    }
  }

  Future<void> _membersTapped() async {
    var viewModel = _getViewModel();
    var users = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: true,
        allowCurrentUser: true,
        selectedUserIds: viewModel.members.items.map((x) => x.teamMember.id).toList(),
      ),
    );
    viewModel.replaceMembers(users);
  }

  Future<void> _adminsTapped() async {
    var viewModel = _getViewModel();
    var users = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: true,
        allowCurrentUser: true,
        selectedUserIds: viewModel.admins.items.map((x) => x.id).toList(),
      ),
    );
    viewModel.replaceAdmins(users);
  }

  ManageTeamViewModel _getViewModel() {
    return Provider.of<ManageTeamViewModel>(context, listen: false);
  }
}
