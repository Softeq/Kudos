import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/viewmodels/achievement_item_viewmodel.dart';

import 'achievement_image_widget.dart';

class AchievementHorizontalWidget extends StatelessWidget {
  final AchievementItemViewModel _achievementItem;

  const AchievementHorizontalWidget(this._achievementItem);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var imageRadius = constraints.maxHeight / 2.0;
        var borderRadius = BorderRadius.only(
          topLeft: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        );
        return Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: imageRadius),
              child: Material(
                elevation: 2,
                borderRadius: borderRadius,
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: Container(
                    padding: EdgeInsets.only(left: imageRadius),
                    height: constraints.maxHeight,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          _achievementItem.description,
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(imageRadius),
              elevation: 2,
              color: Colors.blue,
              child: Hero(
                  child: AchievementImageWidget(
                    imageUrl: _achievementItem.imageUrl,
                    radius: imageRadius,
                  ),
                  tag: _achievementItem.title),
            ),
          ],
        );
      },
    );
  }
}
