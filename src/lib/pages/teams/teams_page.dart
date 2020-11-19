import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/access_level_utils.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/groupped_list_item.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/searchable_list_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/teams_viewmodel.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/groupped_list_widget.dart';
import 'package:kudosapp/widgets/search_input_widget.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:provider/provider.dart';

class TeamsPage extends StatelessWidget {
  final Widget _content = _TeamsContentWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GradientAppBar(title: localizer().teams, elevation: 0),
        body: _content,
      ),
    );
  }
}

class TeamsTab extends StatelessWidget {
  final Widget _content = _TeamsContentWidget();

  @override
  Widget build(BuildContext context) {
    return _content;
  }
}

class _TeamsContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          color: Colors.transparent,
          child: Column(
            children: <Widget>[
              _buildSearchBar(viewModel),
              Expanded(
                child: TopDecorator.buildLayoutWithDecorator(
                  Container(
                    color: KudosTheme.contentColor,
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: _buildList(context, viewModel),
                        ),
                        Positioned.directional(
                          textDirection: TextDirection.ltr,
                          end: 16.0,
                          bottom: 32.0,
                          child: Visibility(
                            visible: viewModel.showAddButton,
                            child: FloatingActionButton(
                              onPressed: () => viewModel.createTeam(),
                              child: KudosTheme.addIcon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar<T>(SearchableListViewModel<T> viewModel) {
    return SearchInputWidget(
      viewModel,
      hintText: localizer().enterName,
      iconSize: 82,
    );
  }

  Widget _buildList(BuildContext context, TeamsViewModel viewModel) {
    return StreamBuilder(
      stream: viewModel.dataStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<Iterable<GrouppedListItem<TeamModel>>> snapshot,
      ) {
        if (viewModel.isBusy || snapshot.data == null) {
          return _buildLoading();
        }
        if (snapshot.data?.isEmpty ?? true) {
          return _buildEmpty(viewModel.isDataListEmpty);
        } else {
          return GrouppedListWidget<TeamModel>(
            snapshot.data,
            (team) => _buildListItem(
              context,
              viewModel,
              team,
            ),
          );
        }
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmpty(bool isAllTeamsListEmpty) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Text(
          isAllTeamsListEmpty
              ? localizer().createYourOwnTeams
              : localizer().searchEmptyPlaceholder,
          textAlign: TextAlign.center,
          style: KudosTheme.sectionEmptyTextStyle,
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    TeamsViewModel viewModel,
    TeamModel team,
  ) {
    return SimpleListItem(
      title: team.name,
      description: AccessLevelUtils.getString(team.accessLevel),
      onTap: () => viewModel.onTeamClicked(context, team),
      selectorIcon: viewModel.selectorIcon,
      imageShape: ImageShape.square(56, 4),
      imageUrl: team.imageUrl,
      useTextPlaceholder: true,
      addHeroAnimation: true,
    );
  }
}
