import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kudosapp/generated/locale_keys.g.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';
import 'package:kudosapp/viewmodels/search_input_viewmodel.dart';
import 'package:kudosapp/widgets/people_list_widget.dart';
import 'package:kudosapp/widgets/search_input_widget.dart';

class PeoplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.people.tr()),
      ),
      body: ChangeNotifierProvider<SearchInputViewModel>(
        create: (context) => SearchInputViewModel(),
        child: Column(
          children: <Widget>[
            SearchInputWidget(
              hintText: "Введите имя", // TODO YP: localize
            ),
            ChangeNotifierProxyProvider<SearchInputViewModel, PeopleViewModel>(
              create: (context) => PeopleViewModel()..initialize(),
              update: (context, searchViewModel, peopleViewModel) {
                return peopleViewModel..filterByName(searchViewModel.query);
              },
              child: Expanded(
                child: PeopleList(
                  (user) {
                    Navigator.of(context).push(ProfileRoute(user.id));
                  },
                  Icon(Icons.navigate_next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
