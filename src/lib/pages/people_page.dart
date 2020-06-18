import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';
import 'package:kudosapp/viewmodels/search_input_viewmodel.dart';
import 'package:kudosapp/widgets/people_list_widget.dart';
import 'package:kudosapp/widgets/search_input_widget.dart';

class PeoplePageRoute extends MaterialPageRoute {
  PeoplePageRoute(
      {Set<String> excludedUserIds,
      Icon selectorIcon,
      Function(BuildContext, User) onItemSelected})
      : super(
          builder: (context) => PeoplePage(
              excludedUserIds: excludedUserIds,
              selectorIcon: selectorIcon,
              onItemSelected: onItemSelected),
          fullscreenDialog: true,
        );
}

class PeoplePage extends StatelessWidget {
  static final Icon defaultSelectorIcon = Icon(Icons.navigate_next);
  static final Function(BuildContext, User) defaultItemSelector =
      (context, user) => Navigator.of(context).push(
            ProfileRoute(user.id),
          );

  final Set<String> _excludedUserIds;
  final Function(BuildContext, User) _onItemSelected;
  final Icon _selectorIcon;

  PeoplePage({
    Set<String> excludedUserIds,
    Icon selectorIcon,
    Function(BuildContext, User) onItemSelected,
  })  : _excludedUserIds = excludedUserIds,
        _selectorIcon = selectorIcon ?? defaultSelectorIcon,
        _onItemSelected = onItemSelected ?? defaultItemSelector;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizer().people),
      ),
      body: ChangeNotifierProvider<SearchInputViewModel>(
        create: (context) => SearchInputViewModel(),
        child: Column(
          children: <Widget>[
            SearchInputWidget(
              hintText: localizer().enterName,
            ),
            ChangeNotifierProxyProvider<SearchInputViewModel, PeopleViewModel>(
              create: (context) =>
                  PeopleViewModel(excludedUserIds: _excludedUserIds)
                    ..initialize(),
              update: (context, searchViewModel, peopleViewModel) {
                return peopleViewModel..filterByName(searchViewModel.query);
              },
              child: Expanded(
                child: PeopleList(
                  (user) => _onItemSelected?.call(context, user),
                  _selectorIcon,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
