import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/image_loader.dart';
import 'package:provider/provider.dart';

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
        title: Text(locator<LocalizationService>().allAchievements),
      ),
      body: Consumer<AchievementsViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case AchievementsViewModelState.busy:
              return Center(
                child: CircularProgressIndicator(),
              );
            case AchievementsViewModelState.ready:
              return _KudosListWidget.from(viewModel.achievements);
            default:
              throw UnimplementedError();
          }
        },
      ),
    );
  }
}

class _KudosListWidget extends StatelessWidget {
  final List<_ListItem> _items;

  factory _KudosListWidget.from(List<Achievement> input) {
    var sortedList = input.toList();
    sortedList
        .sort((x, y) => x.category.orderIndex.compareTo(y.category.orderIndex));

    String groupName;
    var items = List<_ListItem>();
    var achievements = List<Achievement>();
    var addFunction = (List<_ListItem> x, List<Achievement> y) {
      x.add(_LineListItem(y.toList()));
      y.clear();
    };

    for (var i = 0; i < sortedList.length; i++) {
      var item = sortedList[i];

      if (groupName != item.category.name) {
        if (achievements.isNotEmpty) {
          addFunction(items, achievements);
        }

        groupName = item.category.name;
        items.add(_GroupListItem(groupName));
      }

      achievements.add(item);

      if (achievements.length == 2) {
        addFunction(items, achievements);
      }

      if (i == sortedList.length - 1 && achievements.isNotEmpty) {
        addFunction(items, achievements);
      }
    }

    return _KudosListWidget._(items);
  }

  _KudosListWidget._(this._items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _items[index].buid(context);
      },
      itemCount: _items.length,
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
      padding: EdgeInsets.symmetric(
        vertical: 40.0,
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.title,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LineListItem extends _ListItem {
  final List<Achievement> achievements;

  _LineListItem(this.achievements);

  @override
  Widget buid(BuildContext context) {
    List<Widget> widgets;
    var space = 20.0;
    var halfSpace = space / 2.0;
    if (achievements.length == 1) {
      widgets = [
        SizedBox(width: halfSpace),
        Expanded(child: Container()),
        Expanded(
          flex: 2,
          child: _buildItem(achievements[0]),
        ),
        Expanded(child: Container()),
        SizedBox(width: halfSpace),
      ];
    } else {
      widgets = [
        Expanded(child: _buildItem(achievements[0])),
        SizedBox(width: space),
        Expanded(child: _buildItem(achievements[1])),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: widgets,
      ),
    );
  }

  Widget _buildItem(Achievement achievement) {
    var borderRadius = 8.0;
    var contentPadding = 8.0;
    return AspectRatio(
      aspectRatio: 0.54,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var radius = constraints.maxWidth / 2.0;
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: radius,
                ),
                child: Material(
                  elevation: 2,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(contentPadding),
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
                          padding: EdgeInsets.all(contentPadding),
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
                      color: Color.fromARGB(255, 53, 38, 111),
                    ),
                    height: radius * 2.0,
                    width: radius * 2.0,
                    child: ImageLoader(achievement.imageUrl),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
