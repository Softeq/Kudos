import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:provider/provider.dart';

//TODO VPY: complete this screen
class AchievementsRoute extends MaterialPageRoute {
  AchievementsRoute()
      : super(
          builder: (context) {
            return ChangeNotifierProvider<AchievementsViewModel>(
              create: (context) => AchievementsViewModel()..initialize(),
              child: AchievementsPage(),
            );
          },
        );
}

class AchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Achievements"),
      ),
      body: Consumer<AchievementsViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case AchievementsViewModelState.busy:
              return Center(
                child: CircularProgressIndicator(),
              );
            case AchievementsViewModelState.idle:
              return buildList(viewModel);
            default:
              throw UnimplementedError();
          }
        },
      ),
    );
  }

  Widget buildList(AchievementsViewModel viewModel) {
    var sortedList = viewModel.achievements.toList();
    sortedList.sort((x, y) => x.groupName.compareTo(y.groupName));
    var list = List<_ListItem>();
    String groupName;
    List<Achievement> achievements = List<Achievement>();
    for (var i = 0; i < sortedList.length; i++) {
      var item = sortedList[i];

      if (groupName != item.groupName) {
        if (achievements.isNotEmpty) {
          list.add(_LineListItem(achievements));
          achievements.clear();
        }

        groupName = item.groupName;
        list.add(_GroupListItem(groupName));
      }

      achievements.add(item);

      if (achievements.length == 2) {
        list.add(_LineListItem(achievements));
        achievements.clear();
      }

      if (i == sortedList.length - 1 && achievements.isNotEmpty) {
        list.add(_LineListItem(achievements));
        achievements.clear();
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var item = list[index];
        return item.buid(context);
      },
      itemCount: list.length,
    );
  }
}

abstract class _ListItem {
  Widget buid(BuildContext context);
}

class _GroupListItem extends _ListItem {
  final String name;

  _GroupListItem(this.name);

  @override
  Widget buid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        bottom: 24.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }
}

class _LineListItem extends _ListItem {
  final List<Achievement> achievements;

  _LineListItem(List<Achievement> achievements)
      : this.achievements = achievements.toList();

  @override
  Widget buid(BuildContext context) {
    List<Widget> widgets;
    if (achievements.length == 1) {
      widgets = [
        SizedBox(width: 10.0),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 2,
          child: buildTest(achievements[0]),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        SizedBox(width: 10.0),
      ];
    } else {
      widgets = [
        Expanded(
          child: buildTest(achievements[0]),
        ),
        SizedBox(width: 20.0),
        Expanded(
          child: buildTest(achievements[1]),
        ),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Row(
        children: widgets,
      ),
    );
  }

  Widget buildTest(Achievement achievement) {
    return AspectRatio(
      aspectRatio: 0.54,
      child: Padding(
        padding: EdgeInsets.all(0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            var radius = constraints.maxWidth / 2.0;
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: radius,
                    // left: 4.0,
                    // right: 4.0,
                  ),
                  child: Material(
                    elevation: 2,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              achievement.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Divider(
                            height: 0,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              locator<LocalizationService>().testLongText,
                              maxLines: 5,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    borderRadius: BorderRadius.circular(radius),
                    color: Colors.transparent,
                    elevation: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: Colors.white,
                      ),
                      height: radius * 2,
                      width: radius * 2,
                    ),
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
