import 'package:flutter/material.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().people),
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
                  if (snapshot.hasError) {
                    return _buildError(snapshot.error);
                  } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    return _buildList(snapshot.data);
                  } else {
                    return _buildEmpty();
                  }
                  break;
                case ConnectionState.active:
                case ConnectionState.none:
                default:
                  return _buildError("Unknown state");
              }
            },
          );
        }),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        "Error: $error", // TODO YP: temporary
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text("No data"), // TODO YP: temporary
    );
  }

  Widget _buildList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => _buildItem(context, users[index]),
    );
  }

  Widget _buildItem(BuildContext context, User user) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(ProfileRoute(user));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.photoUrl),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
      ),
    );
  }
}