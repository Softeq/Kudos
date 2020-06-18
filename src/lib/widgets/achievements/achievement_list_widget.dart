import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/widgets/achievements/achievement_widget.dart';

class AchievementListWidget extends StatelessWidget {
  final List<Widget> _items;

  factory AchievementListWidget.from(
    List<AchievementModel> input,
    Function(AchievementModel) onAchievementClicked,
  ) {
    var sortedList = input.toList();
    sortedList.sort((x, y) => x.team?.name?.compareTo(y.team?.name) ?? 0);

    String teamName;
    var items = List<Widget>();
    var achievements = List<AchievementModel>();
    var addFunction = (List<Widget> x, List<AchievementModel> y) {
      x.add(AchievementWidget(y.toList(), onAchievementClicked));
      y.clear();
    };

    for (var i = 0; i < sortedList.length; i++) {
      var item = sortedList[i];

      if (teamName != item.team?.name) {
        if (achievements.isNotEmpty) {
          addFunction(items, achievements);
        }

        teamName = item.team.name;
        items.add(_GroupListItem(teamName));
      }

      achievements.add(item);

      if (achievements.length == 2) {
        addFunction(items, achievements);
      }

      if (i == sortedList.length - 1 && achievements.isNotEmpty) {
        addFunction(items, achievements);
      }
    }

    return AchievementListWidget._(items);
  }

  AchievementListWidget._(this._items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _items[index];
      },
      itemCount: _items.length,
      padding: EdgeInsets.only(top: 20.0),
    );
  }
}

class _GroupListItem extends StatelessWidget {
  final String name;

  _GroupListItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 40.0,
      ),
      child: Text(
        name,
        style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,
      ),
    );
  }
}
