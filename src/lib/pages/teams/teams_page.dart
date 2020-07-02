import 'package:flutter/material.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/teams/list_of_teams_widget.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/search_input_viewmodel.dart';
import 'package:kudosapp/widgets/search_input_widget.dart';

class TeamsPageRoute extends MaterialPageRoute {
  TeamsPageRoute({
    Set<String> excludedTeamIds,
    Icon selectorIcon,
    void Function(BuildContext, Team) onItemSelected,
    bool showAddButton,
  }) : super(
          builder: (context) => TeamsPage(
              excludedTeamIds: excludedTeamIds,
              selectorIcon: selectorIcon,
              onItemSelected: onItemSelected,
              showAddButton: showAddButton),
          fullscreenDialog: true,
        );
}

class TeamsPage extends StatelessWidget {
  static final Icon defaultSelectorIcon = Icon(
    Icons.arrow_forward_ios,
    size: 16.0,
    color: KudosTheme.accentColor,
  );
  static final void Function(BuildContext, Team) defaultItemSelector =
      (context, team) => Navigator.of(context).push(
            ManageTeamRoute(team.id),
          );

  final Set<String> _excludedTeamIds;
  final void Function(BuildContext, Team) _onItemSelected;
  final Icon _selectorIcon;
  final bool _showAddButton;

  TeamsPage({
    Set<String> excludedTeamIds,
    Icon selectorIcon,
    Function(BuildContext, Team) onItemSelected,
    bool showAddButton,
  })  : _excludedTeamIds = excludedTeamIds,
        _selectorIcon = selectorIcon ?? defaultSelectorIcon,
        _onItemSelected = onItemSelected ?? defaultItemSelector,
        _showAddButton = showAddButton ?? true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: localizer().teams, elevation: 0),
      body: ChangeNotifierProvider<SearchInputViewModel>(
        create: (context) => SearchInputViewModel(),
        child:
            ChangeNotifierProxyProvider<SearchInputViewModel, MyTeamsViewModel>(
          create: (context) =>
              MyTeamsViewModel(excludedTeamIds: _excludedTeamIds)..initialize(),
          update: (context, searchViewModel, teamsViewModel) =>
              teamsViewModel..filterByName(searchViewModel.query),
          child: Column(
            children: <Widget>[
              _buildSearchBar(),
              Expanded(
                child: TopDecorator.buildLayoutWithDecorator(
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Consumer<MyTeamsViewModel>(
                          builder: (context, viewModel, child) {
                            return StreamBuilder<List<Team>>(
                              stream: viewModel.teamsStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Team>> snapshot) {
                                if (viewModel.isBusy || snapshot.data == null) {
                                  return _buildLoading();
                                }
                                if (snapshot.data.isEmpty) {
                                  return _buildEmpty();
                                } else {
                                  return _buildList(context, snapshot.data);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      Positioned.directional(
                        textDirection: TextDirection.ltr,
                        end: 16.0,
                        bottom: 32.0,
                        child: Visibility(
                          visible: _showAddButton,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.of(context).push(EditTeamRoute());
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
      child: SearchInputWidget(
        hintText: localizer().enterName,
        iconSize: 82,
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Text(localizer().createYourOwnTeams,
            textAlign: TextAlign.center,
            style: KudosTheme.sectionEmptyTextStyle),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Team> teams) {
    return ListOfTeamsWidget(
      padding: EdgeInsets.only(
          top: TopDecorator.height, bottom: BottomDecorator.height),
      onItemSelected: (team) => _onItemSelected?.call(context, team),
      teams: teams,
      selectorIcon: _selectorIcon,
    );
  }
}
