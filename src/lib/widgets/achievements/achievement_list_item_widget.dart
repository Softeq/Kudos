import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';

class AchievementListItemWidget extends StatelessWidget {
  final AchievementModel _achievementModel;
  final void Function(AchievementModel) _onAchievementClicked;

  AchievementListItemWidget(this._achievementModel, this._onAchievementClicked);

  @override
  Widget build(BuildContext context) {
    return SimpleListItem(
      title: _achievementModel.title,
      description: _achievementModel.description,
      onTap: () {
        _onAchievementClicked(_achievementModel);
      },
      imageUrl: _achievementModel.imageViewModel.imageUrl,
      imageShape: ImageShape.circle(80.0),
      useTextPlaceholder: false,
    );
  }
}
