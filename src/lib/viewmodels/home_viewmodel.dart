import 'package:flutter/material.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/teams_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/users_viewmodel.dart';

class TabItem<T> {
  final String iconAssetName;
  final String title;
  final Widget body;

  TabItem({
    @required this.iconAssetName,
    @required this.title,
    @required this.body,
  });
}

class HomeViewModel extends BaseViewModel {
  final _analyticsService = locator<AnalyticsService>();
  final _navigationService = locator<NavigationService>();

  final List<TabItem> tabs = [];

  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  set selectedTabIndex(int value) {
    if (value != _selectedTabIndex) {
      _selectedTabIndex = value;
      notifyListeners();
    }
  }

  TabItem get selectedTab => tabs[_selectedTabIndex];

  HomeViewModel(BuildContext context) {
    _initialize(context);
  }

  void _initialize(BuildContext context) {
    tabs.add(
      TabItem(
        iconAssetName: "assets/icons/profile.svg",
        title: localizer().profileTabName,
        body: _navigationService.getTab(() => MyProfileViewModel()),
      ),
    );
    tabs.add(
      TabItem(
        title: localizer().teamsTabName,
        iconAssetName: "assets/icons/teams.svg",
        body: _navigationService.getTab(
          () => TeamsViewModel(
            SelectionAction.OpenDetails,
            true,
          ),
        ),
      ),
    );
    tabs.add(
      TabItem(
        iconAssetName: "assets/icons/people.svg",
        title: localizer().peopleTabName,
        body: _navigationService.getTab(
          () => UsersViewModel(
            SelectionAction.OpenDetails,
          ),
        ),
      ),
    );
    tabs.add(
      TabItem(
        iconAssetName: "assets/icons/cup.svg",
        title: localizer().achievementsTabName,
        body: _navigationService.getTab(
          () => AchievementsViewModel(
            SelectionAction.OpenDetails,
            true,
          ),
        ),
      ),
    );
  }
}
