import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:kudosapp/pages/achievements/achievement_details_page.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/pages/teams/edit_team_page.dart';
import 'package:kudosapp/pages/teams/manage_team_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/profile/my_achievements_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_profile_viewmodel.dart';
import 'package:kudosapp/viewmodels/profile/my_teams_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_list_widget.dart';
import 'package:kudosapp/widgets/profile_achievement_list_widget.dart';
import 'package:kudosapp/widgets/rounded_image_widget.dart';
import 'package:kudosapp/widgets/vector_icon.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MyProfileViewModel>(context, listen: false);
    final user = viewModel.user;

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 5.0),
                Row(
                  children: <Widget>[
                    SizedBox(width: 16.0),
                    ClipOval(
                      child: Container(
                        color: KudosTheme.textColor,
                        height: 40.0,
                        width: 40.0,
                        child: Center(
                          child: Container(
                            height: 36.0,
                            width: 36.0,
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                user.imageUrl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            user.name,
                            style: KudosTheme.userNameTitleTextStyle,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            user.email,
                            style: KudosTheme.userNameSubTitleTextStyle,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/icons/exit.svg"),
                      onPressed: viewModel.signOut,
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
                TabBar(
                  labelColor: KudosTheme.accentColor,
                  unselectedLabelColor: KudosTheme.textColor,
                  indicatorColor: KudosTheme.accentColor,
                  tabs: <Widget>[
                    Tab(
                      text: localizer().achievements,
                      icon: VectorIcon("assets/icons/star.svg"),
                    ),
                    Tab(
                      text: localizer().teams,
                      icon: VectorIcon("assets/icons/teams.svg"),
                    ),
                    Tab(
                      text: localizer().owner,
                      icon: VectorIcon("assets/icons/owner.svg"),
                    ),
                  ],
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: <Widget>[
                      Positioned.fill(
                        child: TabBarView(
                          children: <Widget>[
                            Container(
                              color: KudosTheme.contentColor,
                              padding: EdgeInsets.all(16.0),
                              child: ProfileAchievementsListWidget(
                                user.id,
                                false,
                              ),
                            ),
                            ChangeNotifierProvider<MyTeamsViewModel>.value(
                              value: viewModel.myTeamsViewModel..initialize(),
                              child: _MyTeamsWidget(),
                            ),
                            ChangeNotifierProvider<
                                MyAchievementsViewModel>.value(
                              value: viewModel.myAchievementsViewModel
                                ..initialize(),
                              child: _MyAchievementsWidget(),
                            ),
                          ],
                        ),
                      ),
                      Positioned.fromRect(
                        child: CustomPaint(
                          painter: _TopPainter(),
                        ),
                        rect: Rect.fromLTWH(
                          0.0,
                          0.0,
                          constraints.maxWidth,
                          46.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MyAchievementsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAchievementsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isBusy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          color: KudosTheme.contentColor,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ChangeNotifierProvider.value(
                  value: viewModel.items,
                  child: Consumer<ListNotifier<AchievementModel>>(
                    builder: (context, notifier, child) {
                      if (notifier.items.isEmpty) {
                        return Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.7,
                            child: Text(
                              localizer().createYourOwnAchievements,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return AchievementListWidget.from(
                        notifier.items,
                        (x) {
                          Navigator.of(context).push(
                            AchievementDetailsRoute(x.achievement.id),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Positioned.directional(
                textDirection: TextDirection.ltr,
                end: 16.0,
                bottom: 16.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      EditAchievementRoute.createUserAchievement(
                        viewModel.currentUser,
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MyTeamsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: KudosTheme.contentColor,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Consumer<MyTeamsViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isBusy) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (viewModel.items.isEmpty) {
                  return Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      child: Text(
                        localizer().createYourOwnTeams,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(top: 24.0),
                  itemCount: viewModel.items.length,
                  itemBuilder: (context, index) {
                    var item = viewModel.items[index];
                    return ListTile(
                      leading: RoundedImageWidget(
                        imageViewModel: item.imageViewModel,
                        name: item.team.name,
                        size: 56.0,
                      ),
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 28.0),
                                  child: Text(
                                    item.team.name,
                                    style: KudosTheme.listTitleTextStyle,
                                  ),
                                ),
                                Container(
                                  height: 1.0,
                                  color: KudosTheme.accentColor,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16.0,
                            color: KudosTheme.accentColor,
                          ),
                        ],
                      ),
                      onTap: () async {
                        Navigator.of(context)
                            .push(ManageTeamRoute(item.team.id));
                      },
                    );
                  },
                );
              },
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            end: 16.0,
            bottom: 32.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(EditTeamRoute());
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawFirstPart(canvas, size);
    _drawSecondPart(canvas, size);
    _drawThirdPart(canvas, size);
  }

  void _drawFirstPart(Canvas canvas, Size size) {
    final x1 = size.width * 0.0 / 254.0;
    final x2 = size.width * 52.4 / 254.0;
    final x3 = size.width * 115.0 / 254.0;
    final x4 = size.width * 115.0 / 254.0;

    final y1 = size.height * 27.0 / 27.0;
    final y2 = size.height * 24.0 / 27.0;
    final y3 = size.height * 14.5 / 27.0;
    final y4 = size.height * 0.0 / 27.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..lineTo(x4, y4)
      ..close();

    final startColor = KudosTheme.mainGradientStartColor;
    final endColor = KudosTheme.mainGradientEndColor;
    final gradient = LinearGradient(
      colors: <Color>[
        Color.fromARGB(
          179,
          startColor.red,
          startColor.green,
          startColor.blue,
        ),
        Color.fromARGB(
          179,
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
    final x2 = size.width * 30.2 / 254.0;
    final x3 = size.width * 88.9 / 254.0;
    final x4 = size.width * 176.9 / 254.0;
    final x5 = size.width * 254.0 / 254.0;

    final y1 = size.height * 3.2 / 27.0;
    final y2 = size.height * 5.8 / 27.0;
    final y3 = size.height * 18.5 / 27.0;
    final y4 = size.height * 32.0 / 27.0;
    final y5 = size.height * 16.1 / 27.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..quadraticBezierTo(x4, y4, x5, y5)
      ..lineTo(size.width, 0.0)
      ..close();

    final startColor = KudosTheme.mainGradientStartColor;
    final endColor = KudosTheme.mainGradientEndColor;
    final gradient = LinearGradient(
      colors: <Color>[
        Color.fromARGB(
          128,
          startColor.red,
          startColor.green,
          startColor.blue,
        ),
        Color.fromARGB(
          128,
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

  void _drawThirdPart(Canvas canvas, Size size) {
    final x1 = size.width * 36.7 / 254.0;
    final x2 = size.width * 50.7 / 254.0;
    final x3 = size.width * 115.0 / 254.0;
    final x4 = size.width * 189.1 / 254.0;
    final x5 = size.width * 254.0 / 254.0;

    final y1 = size.height * 0.0 / 27.0;
    final y2 = size.height * 1.4 / 27.0;
    final y3 = size.height * 14.5 / 27.0;
    final y4 = size.height * 25.6 / 27.0;
    final y5 = size.height * 16.1 / 27.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..quadraticBezierTo(x4, y4, x5, y5)
      ..lineTo(size.width, 0.0)
      ..close();

    var gradient = LinearGradient(
      colors: <Color>[
        KudosTheme.mainGradientStartColor,
        KudosTheme.mainGradientEndColor,
      ],
    );

    var paint = Paint()
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
