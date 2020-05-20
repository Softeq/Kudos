import 'package:flutter/material.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';

class AchievementListWidget extends StatelessWidget {
  final List<Widget> _items;

  factory AchievementListWidget.from(
    List<AchievementViewModel> input,
    Function(AchievementViewModel) onAchievementClicked,
  ) {
    var sortedList = input.toList();
    sortedList.sort((x, y) => x.teamName.compareTo(y.teamName));

    String teamName;
    var items = List<Widget>();
    var achievements = List<AchievementViewModel>();
    var addFunction = (List<Widget> x, List<AchievementViewModel> y) {
      x.add(AchievementWidget(y.toList(), onAchievementClicked));
      y.clear();
    };

    for (var i = 0; i < sortedList.length; i++) {
      var item = sortedList[i];

      if (teamName != item.teamName) {
        if (achievements.isNotEmpty) {
          addFunction(items, achievements);
        }

        teamName = item.teamName;
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
