import 'package:flutter/material.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/models/team_member.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';
import 'package:kudosapp/widgets/circle_image_widget.dart';
import 'package:kudosapp/widgets/fancy_list_widget.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ManageTeamViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildTitle(viewModel);
              } else {
                var lineData = viewModel.getData(index);
                return AchievementWidget(lineData, _achievementTapped);
              }
            },
            itemCount: viewModel.itemsCount,
          ),
          floatingActionButton: viewModel.canEdit
              ? FloatingActionButton(
                  onPressed: _createAchievementTapped,
                  child: Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }

  void _deleteTeam(ManageTeamViewModel viewModel) async {
    bool delete = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(localizer().warning),
            content: Text(localizer().deleteTeamWarning),
            actions: <Widget>[
              FlatButton(
                child: Text(localizer().cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  localizer().delete,
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 59, 48),
                  ),
                ),
                onPressed: () {
                  delete = true;
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    if (delete) {
      await viewModel.delete();
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
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
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: CircleImageWidget.withUrl(
                  viewModel.imageUrl,
                  viewModel.name,
                  45.0,
                ),
              ),
              SizedBox(width: 12),
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
              viewModel.canEdit
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(children: <Widget>[
                        IconButton(
                          onPressed: _editTeamTapped,
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete_forever),
                            onPressed: () => _deleteTeam(viewModel))
                      ]))
                  : Container(),
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
    Navigator.of(context).push(
        EditAchievementRoute.createTeamAchievement(viewModel.modifiedTeam));
  }

  void _achievementTapped(AchievementViewModel x) {
    Navigator.of(context).push(AchievementDetailsRoute(x.achievement.id));
  }

  Future<void> _editTeamTapped() async {
    var viewModel = _getViewModel();
    var team = await Navigator.of(context).push(
      EditTeamRoute(viewModel.modifiedTeam),
    );
    if (team != null) {
      viewModel.updateTeamMetadata(
        team.name,
        team.description,
        team.imageUrl,
        team.imageName,
      );
    }
  }

  Future<void> _membersTapped() async {
    var viewModel = _getViewModel();
    if (!viewModel.canEdit) {
      return;
    }

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
    if (!viewModel.canEdit) {
      return;
    }

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
