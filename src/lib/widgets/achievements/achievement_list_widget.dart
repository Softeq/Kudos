import 'package:flutter/material.dart';
import 'package:kudosapp/extensions/list_extensions.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';

class AchievementListWidget extends StatelessWidget {
  final List<Widget> _items;

  factory AchievementListWidget.from(
    List<AchievementModel> input,
    void Function(AchievementModel) onAchievementClicked,
  ) {
    final sortedList = input.toList();
    sortedList.sortThen(
      (x, y) {
        if (x.team == null && y.team != null) {
          return -1;
        } else if (x.team != null && y.team == null) {
          return 1;
        } else {
          return 0;
        }
      },
      (x, y) {
        if (x.team == null && y.team == null) {
          return 0;
        }

        return x.team.name.compareTo(y.team.name);
      },
    );

    final myAchievementsText = localizer().myAchievements;
    final listItems = List<Widget>();
    String groupName;

    for (var i = 0; i < sortedList.length; i++) {
      final item = sortedList[i];
      final itemGroup = item.team == null ? myAchievementsText : item.team.name;
      if (groupName != itemGroup) {
        groupName = itemGroup;
        listItems.add(_GroupListItem(itemGroup));
      }
      listItems.add(_ListItem(item, onAchievementClicked));
    }

    return AchievementListWidget._(listItems);
  }

  AchievementListWidget._(this._items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _items[index];
      },
      itemCount: _items.length,
      padding: EdgeInsets.only(bottom: 28.0),
    );
  }
}

class _GroupListItem extends StatelessWidget {
  final String name;

  _GroupListItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        name,
        style: KudosTheme.listGroupTitleTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final AchievementModel _achievementModel;
  final void Function(AchievementModel) _onAchievementClicked;

  _ListItem(this._achievementModel, this._onAchievementClicked);

  @override
  Widget build(BuildContext context) {
    return SimpleListItem(
      title: _achievementModel.title,
      description: _achievementModel.description,
      onTap: () {
        _onAchievementClicked(_achievementModel);
      },
      imageViewModel: _achievementModel.imageViewModel,
      imageShape: ImageShape.circle(80.0),
    );
  }
}
