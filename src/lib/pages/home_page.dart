import 'package:flutter/material.dart';
import 'package:kudosapp/pages/my_profile_page.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/my_profile_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/achievements_page.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';

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

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    _tabs.add(_TabItem(
      title: locator<LocalizationService>().allAchievements,
      body: ChangeNotifierProvider<AchievementsViewModel>(
        create: (context) => AchievementsViewModel()..initialize(),
        child: AchievementsPage(),
      ),
    ));

    _tabs.add(_TabItem(
      title: locator<LocalizationService>().people,
      body: ChangeNotifierProvider<PeopleViewModel>(
        create: (context) => PeopleViewModel(),
        child: PeoplePage(),
      ),
    ));

    _tabs.add(
      _TabItem(
        title: locator<LocalizationService>().profile,
        body: ChangeNotifierProxyProvider<AuthViewModel, MyProfileViewModel>(
          create: (context) => null,
          update: (context, authViewModel, _) {
            return MyProfileViewModel(
              authViewModel,
              ProfileViewModel(authViewModel.currentUser),
            );
          },
          child: MyProfilePage(),
        ),
      ),
    );
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
      appBar: AppBar(
        title: Text(activeTab.title),
      ),
      body: activeTab.body,
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildNavigationBar() {
    return BottomNavigationBar(
      onTap: _selectTab,
      currentIndex: _selectedTabIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      backgroundColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          title: Text(_tabs[0].title),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          title: Text(_tabs[1].title),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text(_tabs[2].title),
        ),
      ],
    );
  }
}

class _TabItem {
  final String title;
  final Object body;

  _TabItem({
    @required this.title,
    @required this.body,
  });
}
