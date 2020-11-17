import 'package:flutter/widgets.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/services/database/mandatory_update_database_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/services/page_mapper_service.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/viewmodels/teams/teams_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/users_viewmodel.dart';

class TabItem<T> {
  final String iconAssetName;
  final String title;
  final String tabName;
  final Widget body;

  TabItem({
    @required this.iconAssetName,
    @required this.title,
    @required this.tabName,
    @required this.body,
  });
}

class HomeViewModel extends BaseViewModel {
  final _analyticsService = locator<AnalyticsService>();
  final _pageMapperService = locator<PageMapperService>();
  final _navigationService = locator<NavigationService>();
  final _mandatoryUpdateDatabaseService =
      locator<MandatoryUpdateDatabaseService>();

  final List<TabItem> tabs = [];

  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;

  set selectedTabIndex(int value) {
    if (value != _selectedTabIndex) {
      _selectedTabIndex = value;
      _analyticsService.setCurrentScreen(tabs[_selectedTabIndex].tabName);
      notifyListeners();
    }
  }

  TabItem get selectedTab => tabs[_selectedTabIndex];

  HomeViewModel(BuildContext context) {
    _initialize(context);
  }

  void _initialize(BuildContext context) {
    _mandatoryUpdateDatabaseService.refreshSubscriptions();

    tabs.add(
      TabItem(
        title: localizer().profileTabName,
        iconAssetName: "assets/icons/profile.svg",
        tabName: _pageMapperService.getTabName<MyProfileViewModel>(),
        body: _navigationService.getTab(() => MyProfileViewModel()),
      ),
    );
    tabs.add(
      TabItem(
        title: localizer().teamsTabName,
        iconAssetName: "assets/icons/teams.svg",
        tabName: _pageMapperService.getTabName<TeamsViewModel>(),
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
        title: localizer().peopleTabName,
        iconAssetName: "assets/icons/people.svg",
        tabName: _pageMapperService.getTabName<UsersViewModel>(),
        body: _navigationService.getTab(
          () => UsersViewModel(
            SelectionAction.OpenDetails,
          ),
        ),
      ),
    );
    tabs.add(
      TabItem(
        title: localizer().achievementsTabName,
        iconAssetName: "assets/icons/cup.svg",
        tabName: _pageMapperService.getTabName<AchievementsViewModel>(),
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
