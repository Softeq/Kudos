import 'package:flutter/material.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/viewmodels/teams/teams_viewmodel.dart';
import 'package:provider/provider.dart';

//TODO VPY: tmp
class TeamsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  viewModel.refresh();
                },
                child: Text("refresh"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.teams.length,
                  itemBuilder: (context, index) {
                    var item = viewModel.teams[index];
                    return ListTile(
                      title: Text(item.name),
                      onTap: () async {
                        var team = await viewModel.loadTeam(item.id);
                        Navigator.of(context).push(ManageTeamRoute(team));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(EditTeamRoute());
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
