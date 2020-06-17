import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/widgets/rounded_image_widget.dart';
import 'package:provider/provider.dart';

class MyTeamsRoute extends MaterialPageRoute {
  MyTeamsRoute(Icon itemSelectorIcon, Function(BuildContext, Team) itemSelector)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<MyTeamsViewModel>.value(
                value: MyTeamsViewModel()..initialize(),
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        localizer().chooseTeam,
                      ),
                    ),
                    body: MyTeamsWidget.withCustomSelector(
                        itemSelectorIcon, itemSelector)));
          },
          fullscreenDialog: true,
        );
}

class MyTeamsWidget extends StatelessWidget {
  final Icon customIcon;
  final Function(BuildContext, Team) customItemSelector;
  final bool useCustomSelector;

  MyTeamsWidget.withCustomSelector(this.customIcon, this.customItemSelector)
      : useCustomSelector = true;

  MyTeamsWidget()
      : useCustomSelector = false,
        customItemSelector = null,
        customIcon = null;

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
                                  child: useCustomSelector
                                      ? customIcon
                                      : Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16.0,
                                          color: KudosTheme.accentColor,
                                        ),
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
                      onTap: () {
                        useCustomSelector
                            ? customItemSelector?.call(context, item.team)
                            : Navigator.of(context).push(
                                ManageTeamRoute(item.team.id),
                              );
                      },
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
