import 'package:flutter/material.dart';
import 'package:kudosapp/dto/team_member.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/teams/manage_team_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/achievement_widget.dart';
import 'package:kudosapp/widgets/common/fancy_list_widget.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/section_header_widget.dart';
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
            appBar: GradientAppBar(title: viewModel?.name),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          appBar: GradientAppBar(
            title: viewModel.name,
            actions: viewModel.canEdit
                ? <Widget>[
                    IconButton(
                        icon: Icon(Icons.edit), onPressed: _editTeamTapped),
                    IconButton(
                        icon: Icon(Icons.delete_forever),
                        onPressed: () => viewModel.deleteTeam(context)),
                  ]
                : null,
          ),
          body: _buildBody(viewModel),
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

  Widget _buildBody(ManageTeamViewModel viewModel) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(children: <Widget>[
          viewModel.imageViewModel.file == null &&
                  (viewModel.imageViewModel.imageUrl == null ||
                      viewModel.imageViewModel.imageUrl.isEmpty)
              ? Container()
              : RoundedImageWidget.square(
                  imageViewModel: viewModel.imageViewModel,
                  size: 112.0,
                  borderRadius: 8,
                  name: viewModel.name,
                ),
          SizedBox(height: 24),
          Text(
            viewModel.description,
            style: KudosTheme.descriptionTextStyle,
          ),
          SizedBox(height: 24.0),
          GestureDetector(
            onTap: _adminsTapped,
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SectionHeaderWidget(localizer().admins),
                  SizedBox(height: 10.0),
                  FancyListWidget<TeamMember>(
                    viewModel.admins,
                    (TeamMember member) => member.name,
                    localizer().addPeople,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SectionHeaderWidget(localizer().members),
                  SizedBox(height: 10.0),
                  FancyListWidget<TeamMember>(
                    viewModel.members,
                    (TeamMember member) => member.name,
                    localizer().addPeople,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.0),
          SectionHeaderWidget(localizer().achievements),
          SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var lineData = viewModel.getData(index);
              return AchievementWidget(lineData, _achievementTapped);
            },
            itemCount: viewModel.itemsCount,
          )
        ]));
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
        searchHint: localizer().searchMembers,
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
        searchHint: localizer().searchAdmins,
        selectedUserIds: viewModel.admins.items.map((x) => x.id).toList(),
      ),
    );
    viewModel.replaceAdmins(users);
  }

  ManageTeamViewModel _getViewModel() {
    return Provider.of<ManageTeamViewModel>(context, listen: false);
  }
}
