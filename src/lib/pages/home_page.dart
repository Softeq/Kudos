import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/achievements/achievements_page.dart';
import 'package:kudosapp/pages/people_page.dart';
import 'package:kudosapp/pages/profile/my_profile_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_profile_viewmodel.dart';
import 'package:kudosapp/widgets/vector_icon.dart';
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            KudosTheme.mainGradientStartColor,
            KudosTheme.mainGradientEndColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                Positioned.fill(child: activeTab.body),
                Positioned.fromRect(
                  child: CustomPaint(
                    painter: _BottomPainter(),
                  ),
                  rect: Rect.fromLTWH(
                    0.0,
                    constraints.maxHeight - 25.5,
                    constraints.maxWidth,
                    26.0,
                  ),
                ),
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

class _BottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawFirstPart(canvas, size);
    _drawSecondPart(canvas, size);
  }

  void _drawFirstPart(Canvas canvas, Size size) {
    final x1 = size.width * 34.9 / 254.0;
    final x2 = size.width * 90.0 / 254.0;
    final x3 = size.width * 158.5 / 254.0;

    final y1 = size.height * 2.9 / 16.2;
    final y2 = size.height * -1.7 / 16.2;
    final y3 = size.height * 9.5 / 16.2;

    final path = Path()
      ..moveTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..lineTo(x3, size.height)
      ..lineTo(x1, size.height)
      ..close();

    final startColor = KudosTheme.mainGradientStartColor;
    final endColor = KudosTheme.mainGradientStartColor;
    final gradient = LinearGradient(
      colors: <Color>[
        Color.fromARGB(
          125,
          startColor.red,
          startColor.green,
          startColor.blue,
        ),
        Color.fromARGB(
          125,
          endColor.red,
          endColor.green,
          endColor.blue,
        ),
      ],
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  void _drawSecondPart(Canvas canvas, Size size) {
    final x1 = size.width * 0.0 / 254.0;
    final x2 = size.width * 53.3 / 254.0;
    final x3 = size.width * 113.0 / 254.0;
    final x4 = size.width * 224.2 / 254.0;
    final x5 = size.width * 254.0 / 254.0;

    final y1 = size.height * 0.0 / 16.2;
    final y2 = size.height * 3.4 / 16.2;
    final y3 = size.height * 15.6 / 16.2;
    final y4 = size.height * -1.3 / 16.2;
    final y5 = size.height * 0 / 16.2;

    final path = Path()
      ..moveTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..quadraticBezierTo(x4, y4, x5, y5)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    final gradient = LinearGradient(
      colors: <Color>[
        KudosTheme.mainGradientStartColor,
        KudosTheme.mainGradientEndColor,
      ],
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
