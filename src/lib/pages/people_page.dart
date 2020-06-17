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
      Icon itemSelectorIcon, Function(BuildContext, User) itemSelector)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<PeopleViewModel>(
              create: (context) {
                return PeopleViewModel(excludeCurrentUser: false);
              },
              child:
                  PeoplePage.withCustomSelector(itemSelectorIcon, itemSelector),
            );
          },
          fullscreenDialog: true,
        );
}

class PeoplePage extends StatelessWidget {
  final Icon customIcon;
  final Function(BuildContext, User) customItemSelector;
  final bool useCustomSelector;

  PeoplePage.withCustomSelector(this.customIcon, this.customItemSelector)
      : useCustomSelector = true;

  PeoplePage()
      : useCustomSelector = false,
        customItemSelector = null,
        customIcon = null;

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
              create: (context) => PeopleViewModel()..initialize(),
              update: (context, searchViewModel, peopleViewModel) {
                return peopleViewModel..filterByName(searchViewModel.query);
              },
              child: Expanded(
                child: PeopleList(
                  (user) {
                    useCustomSelector
                        ? customItemSelector?.call(context, user)
                        : Navigator.of(context).push(ProfileRoute(user.id));
                  },
                  useCustomSelector ? customIcon : Icon(Icons.navigate_next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
