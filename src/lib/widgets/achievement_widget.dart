import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/pages/achievement_page.dart';
import 'package:kudosapp/viewmodels/achievement_item_viewmodel.dart';
import 'package:kudosapp/widgets/image_loader.dart';

class AchievementWidget extends StatelessWidget {
  final List<AchievementItemViewModel> achievements;

  AchievementWidget(this.achievements);

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

  Widget _buildItem(AchievementItemViewModel achievement) {
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
                      Navigator.of(context)
                          .push(AchievementRoute(achievement.model));
                    },
                    child: Hero(
                      child: _AchievementImageWidget(
                        file: achievement.file,
                        imageUrl: achievement.imageUrl,
                        radius: radius,
                        isBusy: achievement.isFileLoading,
                      ),
                      tag: achievement.title,
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

class _AchievementImageWidget extends StatelessWidget {
  final File file;
  final String imageUrl;
  final double radius;
  final bool isBusy;

  _AchievementImageWidget({
    this.file,
    this.imageUrl,
    this.radius,
    this.isBusy,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    Color color = Colors.white;

    if (isBusy) {
      child = Center(
        child: CircularProgressIndicator(),
      );
    } else if (file != null) {
      color = Color.fromARGB(255, 53, 38, 111);
      child = SvgPicture.file(file);
    } else if (imageUrl != null) {
      color = Color.fromARGB(255, 53, 38, 111);
      child = ImageLoader(imageUrl);
    }

    return ClipOval(
      child: Container(
        color: color,
        child: child,
        height: radius * 2.0,
        width: radius * 2.0,
      ),
    );
  }
}
