import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/achievements/achievements_page.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/pages/profile/my_profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_profile_viewmodel.dart';
import 'package:kudosapp/widgets/common/vector_icon.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<_TabItem> _tabs = [];

  int _selectedTabIndex = 0;

  @override
  void didChangeDependencies() {
    _tabs.clear();
    _tabs.addAll(_buildTabs(context));

    super.didChangeDependencies();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeTab = _tabs[_selectedTabIndex];
    return Container(
      decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                Positioned.fill(child: activeTab.body),
                Positioned.directional(
                    textDirection: TextDirection.ltr,
                    child: BottomDecorator(constraints.maxWidth),
                    bottom: 0),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildNavigationBar(),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectTab,
        currentIndex: _selectedTabIndex,
        selectedItemColor: KudosTheme.accentColor,
        unselectedItemColor: KudosTheme.textColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        items: _tabs.map((tab) {
          return BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: tab.icon,
            ),
            title: Text(tab.title),
          );
        }).toList(),
      ),
    );
  }

  List<_TabItem> _buildTabs(BuildContext context) {
    return [
      _TabItem(
        icon: VectorIcon("assets/icons/profile.svg"),
        title: localizer().profile,
        body: ChangeNotifierProvider<MyProfileViewModel>(
          create: (context) => MyProfileViewModel(),
          child: MyProfilePage(),
        ),
      ),
      _TabItem(
        icon: VectorIcon("assets/icons/people.svg"),
        title: localizer().people,
        body: PeoplePage(),
      ),
      _TabItem(
        icon: VectorIcon("assets/icons/cup.svg"),
        title: localizer().allAchievements,
        body: ChangeNotifierProvider<AchievementsViewModel>(
          create: (context) => AchievementsViewModel()..initialize(),
          child: AchievementsPage(),
        ),
      ),
    ];
  }
}

class _TabItem {
  final Widget icon;
  final String title;
  final Object body;

  _TabItem({
    @required this.icon,
    @required this.title,
    @required this.body,
  });
}
