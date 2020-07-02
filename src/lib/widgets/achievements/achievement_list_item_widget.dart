import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';

class AchievementListItemWidget extends StatelessWidget {
  final Achievement _achievement;
  final void Function(Achievement) _onAchievementClicked;

  AchievementListItemWidget(this._achievement, this._onAchievementClicked);

  @override
  Widget build(BuildContext context) {
    return SimpleListItem(
      title: _achievement.name,
      description: _achievement.description,
      onTap: () {
        _onAchievementClicked(_achievement);
      },
      imageUrl: _achievement.imageUrl,
      imageShape: ImageShape.circle(80.0),
      useTextPlaceholder: false,
      addHeroAnimation: true,
    );
  }
}
