import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';
import 'package:kudosapp/widgets/fancy_list_widget.dart';

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
          if (viewModel.isBusy) {
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

  Widget _buildTitle(ManageTeamViewModel viewModel) {
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
                  localizer().admins,
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
                  localizer().members,
                  style: textTheme.caption,
                ),
                SizedBox(height: 6.0),
                FancyListWidget<TeamMember>(
                  viewModel.members,
                  (TeamMember member) => member.name,
                  localizer().addPeople,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 32.0),
      ],
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
      viewModel.updateTeamMetadata(team.name, team.description);
    }
  }

  Future<void> _membersTapped() async {
    var viewModel = _getViewModel();
    var users = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: true,
        allowCurrentUser: true,
        selectedUserIds: viewModel.members.items.map((x) => x.id).toList(),
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
