import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';

class ListOfTeamsWidget extends StatelessWidget {
  static final Icon defaultSelectorIcon = Icon(
    Icons.arrow_forward_ios,
    size: 16.0,
    color: KudosTheme.accentColor,
  );
  static final void Function(BuildContext, TeamModel) defaultItemSelector =
      (context, team) => Navigator.of(context).push(
            ManageTeamRoute(team),
          );

  final void Function(TeamModel) _onItemSelected;
  final Icon _selectorIcon;
  final List<TeamModel> teams;
  final EdgeInsets padding;

  ListOfTeamsWidget({
    this.padding,
    this.teams,
    Icon selectorIcon,
    Function(TeamModel) onItemSelected,
  })  : _selectorIcon = selectorIcon ?? defaultSelectorIcon,
        _onItemSelected = onItemSelected ?? defaultItemSelector;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: teams.length,
      itemBuilder: (context, index) {
        var team = teams[index];
        return SimpleListItem(
          title: team.name,
          onTap: () => _onItemSelected?.call(team),
          selectorIcon: _selectorIcon,
          imageShape: ImageShape.square(56, 4),
          imageUrl: team.imageUrl,
          useTextPlaceholder: true,
          addHeroAnimation: true,
        );
      },
    );
  }
}
