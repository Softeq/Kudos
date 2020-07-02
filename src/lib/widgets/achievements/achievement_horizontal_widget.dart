import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';

class AchievementHorizontalWidget extends StatelessWidget {
  final Achievement _achievement;

  const AchievementHorizontalWidget(this._achievement);

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
                          _achievement.description,
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.center,
                          style: KudosTheme.listSubTitleTextStyle,
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
              child: RoundedImageWidget.circular(
                imageUrl: _achievement.imageUrl,
                size: imageRadius * 2,
              ),
            ),
          ],
        );
      },
    );
  }
}
