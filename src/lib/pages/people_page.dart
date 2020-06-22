import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/list_of_people_widget.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/profile_page.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';
import 'package:kudosapp/viewmodels/search_input_viewmodel.dart';
import 'package:kudosapp/widgets/search_input_widget.dart';

class PeoplePageRoute extends MaterialPageRoute {
  PeoplePageRoute(
      {Set<String> excludedUserIds,
      Icon selectorIcon,
      void Function(BuildContext, User) onItemSelected})
      : super(
          builder: (context) => PeoplePage(
              excludedUserIds: excludedUserIds,
              selectorIcon: selectorIcon,
              onItemSelected: onItemSelected),
          fullscreenDialog: true,
        );
}

class PeoplePage extends StatelessWidget {
  static final Icon defaultSelectorIcon = Icon(
    Icons.arrow_forward_ios,
    size: 16.0,
    color: KudosTheme.accentColor,
  );
  static final void Function(BuildContext, User) defaultItemSelector =
      (context, user) => Navigator.of(context).push(
            ProfileRoute(user.id),
          );

  final Set<String> _excludedUserIds;
  final void Function(BuildContext, User) _onItemSelected;
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
      appBar: GradientAppBar(title: localizer().people),
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
                child: Consumer<PeopleViewModel>(
                    builder: (context, viewModel, child) {
                  return StreamBuilder<List<User>>(
                    stream: viewModel.people,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<User>> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.isEmpty) {
                          return _buildEmpty();
                        }
                        return _buildList(context, snapshot.data);
                      }
                      if (snapshot.hasError) {
                        return _buildError(snapshot.error);
                      }
                      return _buildLoading();
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildList(BuildContext context, List<User> users) {
    return ListOfPeopleWidget(
      itemSelector: (user) => _onItemSelected?.call(context, user),
      users: users,
      trailingWidget: _selectorIcon,
    );
  }
}
