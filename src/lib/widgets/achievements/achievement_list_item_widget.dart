import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';

class AchievementListItemWidget extends StatelessWidget {
  final AchievementModel _achievement;
  final void Function(AchievementModel) _onAchievementClicked;
  final Icon _selectorIcon;

  AchievementListItemWidget(
    this._achievement,
    this._onAchievementClicked,
    this._selectorIcon,
  );

  @override
  Widget build(BuildContext context) {
    return SimpleListItem(
      title: _achievement.name,
      description: _achievement.description,
      onTap: () {
        _onAchievementClicked(_achievement);
      },
      selectorIcon: _selectorIcon,
      imageUrl: _achievement.imageUrl,
      imageShape: ImageShape.circle(80.0),
      useTextPlaceholder: false,
      addHeroAnimation: true,
    );
  }
}
