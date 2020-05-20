import 'package:flutter/material.dart';
import 'package:kudosapp/pages/achievements_page.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/pages/profile/my_profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_profile_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<_TabItem> _tabs = [];

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabs.add(
      _TabItem(
        icon: Icons.person,
        title: locator<LocalizationService>().profile,
        body: ChangeNotifierProvider<MyProfileViewModel>(
          create: (context) => MyProfileViewModel(),
          child: MyProfilePage(),
        ),
      ),
    );

    _tabs.add(_TabItem(
      icon: Icons.people,
      title: locator<LocalizationService>().people,
      body: PeoplePage(),
    ));

    _tabs.add(_TabItem(
      icon: Icons.category,
      title: locator<LocalizationService>().allAchievements,
      body: ChangeNotifierProvider<AchievementsViewModel>(
        create: (context) => AchievementsViewModel()..initialize(),
        child: AchievementsPage(),
      ),
    ));
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = _tabs[_selectedTabIndex];

    return Scaffold(
      body: activeTab.body,
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _selectTab,
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      backgroundColor: Theme.of(context).primaryColor,
      items: _tabs
          .map((tab) => BottomNavigationBarItem(
                icon: Icon(tab.icon),
                title: Text(tab.title),
              ))
          .toList(),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String title;
  final Object body;

  _TabItem({
    @required this.icon,
    @required this.title,
    @required this.body,
  });
}
