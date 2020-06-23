import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:provider/provider.dart';

class MyTeamsRoute extends MaterialPageRoute {
  MyTeamsRoute({
    Set<String> excludedTeamIds,
    Icon selectorIcon,
    void Function(BuildContext, Team) onItemSelected,
  }) : super(
          builder: (context) {
            return ChangeNotifierProvider<MyTeamsViewModel>.value(
                value: MyTeamsViewModel(excludedTeamIds: excludedTeamIds)
                  ..initialize(),
                child: Scaffold(
                    appBar: GradientAppBar(title: localizer().chooseTeam),
                    body: MyTeamsWidget(
                        selectorIcon: selectorIcon,
                        onItemSelected: onItemSelected)));
          },
          fullscreenDialog: true,
        );
}

class MyTeamsWidget extends StatelessWidget {
  static final Icon defaultSelectorIcon = Icon(
    Icons.arrow_forward_ios,
    size: 16.0,
    color: KudosTheme.accentColor,
  );
  static final void Function(BuildContext, Team) defaultItemSelector =
      (context, team) => Navigator.of(context).push(
            ManageTeamRoute(team.id),
          );

  final void Function(BuildContext, Team) _onItemSelected;
  final Icon _selectorIcon;

  MyTeamsWidget({
    Icon selectorIcon,
    Function(BuildContext, Team) onItemSelected,
  })  : _selectorIcon = selectorIcon ?? defaultSelectorIcon,
        _onItemSelected = onItemSelected ?? defaultItemSelector;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KudosTheme.contentColor,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Consumer<MyTeamsViewModel>(
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
                        localizer().createYourOwnTeams,
                        textAlign: TextAlign.center,
                        style: KudosTheme.sectionEmptyTextStyle
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 46.0),
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    var item = viewModel.items[index];
                    return SimpleListItem(
                      title: item.team.name,
                      onTap: () => _onItemSelected?.call(context, item.team),
                      selectorIcon: _selectorIcon,
                      imageShape: ImageShape.square(56, 4),
                      imageViewModel: item.imageViewModel,
                    );
                  },
                );
              },
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            end: 16.0,
            bottom: 32.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(EditTeamRoute());
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
