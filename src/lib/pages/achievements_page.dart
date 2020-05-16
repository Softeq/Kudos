import 'package:flutter/material.dart';
import 'package:kudosapp/pages/achievement_details_page.dart';
import 'package:kudosapp/viewmodels/achievement_viewmodel.dart';
import 'package:kudosapp/viewmodels/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';
import 'package:provider/provider.dart';

class AchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AchievementsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _KudosListWidget.from(viewModel.achievements, (x) {
              Navigator.of(context)
                  .push(AchievementDetailsRoute(x.achievement));
            });
          }
        },
      ),
    );
  }
}

class _KudosListWidget extends StatelessWidget {
  final List<Widget> _items;

  factory _KudosListWidget.from(
    List<AchievementViewModel> input,
    Function(AchievementViewModel) onAchievementClicked,
  ) {
    var sortedList = input.toList();
    sortedList.sort((x, y) => x.group.compareTo(y.group));

    String groupName;
    var items = List<Widget>();
    var achievements = List<AchievementViewModel>();
    var addFunction = (List<Widget> x, List<AchievementViewModel> y) {
      x.add(AchievementWidget(y.toList(), onAchievementClicked));
      y.clear();
    };

    for (var i = 0; i < sortedList.length; i++) {
      var item = sortedList[i];

      if (groupName != item.group) {
        if (achievements.isNotEmpty) {
          addFunction(items, achievements);
        }

        groupName = item.group;
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
