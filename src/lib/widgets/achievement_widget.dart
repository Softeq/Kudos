import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/widgets/circle_image_widget.dart';

class AchievementWidget extends StatelessWidget {
  final List<AchievementModel> achievements;
  final Function(AchievementModel) onAchievementClicked;

  AchievementWidget(this.achievements, [this.onAchievementClicked]);

  @override
  Widget build(BuildContext context) {
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

  Widget _buildItem(AchievementModel achievement) {
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(contentPadding),
                        child: Text(
                          achievement.title,
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
                          achievement.description,
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  borderRadius: BorderRadius.circular(radius),
                  elevation: 2,
                  child: GestureDetector(
                    onTap: () {
                      onAchievementClicked(achievement);
                    },
                    child: CircleImageWidget(
                      imageViewModel: achievement.imageViewModel,
                      size: radius*2,
                    ),
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
