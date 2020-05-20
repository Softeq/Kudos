import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/widgets/image_loader_widget.dart';

class AchievementImageWidget extends StatelessWidget {
  final File file;
  final String imageUrl;
  final double radius;
  final bool isBusy;

  AchievementImageWidget({
    this.file,
    this.imageUrl,
    this.radius,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    Color color = Colors.white;

    if (isBusy) {
      child = Center(
        child: CircularProgressIndicator(),
      );
    } else if (imageUrl != null || file != null) {
      color = Color.fromARGB(255, 53, 38, 111);
      child = ImageLoaderWidget(
        url: imageUrl,
        file: file,
      );
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
