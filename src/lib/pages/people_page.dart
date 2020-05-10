import 'package:flutter/material.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/widgets/people_list_widget.dart';
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
      body: PeopleList((user) {
        Navigator.of(context).push(ProfileRoute(user));
      }),
    );
  }
}
