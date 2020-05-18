import 'package:flutter/material.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/widgets/people_list_widget.dart';

class PeoplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().people),
      ),
      body: PeopleList(
        (user) {
          Navigator.of(context).push(ProfileRoute(user));
        },
        Icon(Icons.navigate_next),
      ),
    );
  }
}
