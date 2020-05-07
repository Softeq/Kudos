import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';

class PeopleRoute extends MaterialPageRoute {
  PeopleRoute()
    : super(
        builder: (context) {
          return ChangeNotifierProvider<PeopleViewModel>(
            create: (context) => PeopleViewModel(),
            child: PeoplePage(),
          );
        },
      );
}

class PeoplePage extends StatelessWidget {

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("People"),
      ),
      body: Consumer<PeopleViewModel>(
        builder: (context, viewModel, child) {
          return FutureBuilder<List<User>>(
            future: viewModel.people,
            builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return _buildLoading();
                case ConnectionState.done:
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final user = snapshot.data[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      );
                    });
                case ConnectionState.active:
                  return Center(child: Text("Active"));
                case ConnectionState.none:
                default:
                  return Center(child: Text("None"));
              }
            },
          );
        }),
    );
  }
}