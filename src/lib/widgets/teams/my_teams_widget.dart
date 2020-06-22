import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
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

  final void Function(BuildContext, Team) onItemSelected;
  final Icon selectorIcon;

  MyTeamsWidget({
    Icon selectorIcon,
    Function(BuildContext, Team) onItemSelected,
  })  : selectorIcon = selectorIcon ?? defaultSelectorIcon,
        onItemSelected = onItemSelected ?? defaultItemSelector;

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
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 24.0),
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    var item = viewModel.items[index];
                    return GestureDetector(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: RoundedImageWidget.rect(
                                    imageViewModel: item.imageViewModel,
                                    name: item.team.name,
                                    size: 56.0,
                                    borderRadius: 4.0,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    item.team.name,
                                    style: KudosTheme.listTitleTextStyle,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: selectorIcon,
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                                left: 76.0,
                              ),
                              height: 1.0,
                              color: KudosTheme.accentColor,
                            ),
                          ],
                        ),
                      ),
                      onTap: () => onItemSelected?.call(context, item.team),
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
