import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/teams/user_teams_viewmodel.dart';

class UserTeamsWidget extends StatelessWidget {
  final String _userId;

  UserTeamsWidget(this._userId);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserTeamsViewModel>(
      create: (context) => UserTeamsViewModel()..initialize(_userId),
      child: Consumer<UserTeamsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.teamNames.isEmpty) {
            return Container();
          }

          var widgets = viewModel.teamNames.map(
            (x) {
              return Chip(
                label: Text(x),
              );
            },
          ).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                localizer().teams,
                style: Theme.of(context).textTheme.caption,
              ),
              Wrap(
                spacing: 8.0,
                children: widgets,
              ),
            ],
          );
        },
      ),
    );
  }
}
