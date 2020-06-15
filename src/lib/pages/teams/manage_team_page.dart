import 'package:flutter/material.dart';
import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';
import 'package:kudosapp/widgets/fancy_list_widget.dart';
import 'package:kudosapp/widgets/rounded_image_widget.dart';
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
                child: RoundedImageWidget.circular(
                  imageViewModel: viewModel.imageViewModel,
                  size: 46.0,
                  name: viewModel.name,
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
                            onPressed: () => viewModel.deleteTeam(context))
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

  void _achievementTapped(AchievementModel x) {
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
