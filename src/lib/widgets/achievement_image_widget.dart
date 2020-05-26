import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class AchievementImageWidget extends StatelessWidget {
  final ImageViewModel imageViewModel;
  final double radius;

  AchievementImageWidget({
    this.imageViewModel,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageViewModel>.value(
      value: imageViewModel,
      child: Consumer<ImageViewModel>(
        builder: (context, viewModel, child) {
          Widget child = Container();
          Color color = Colors.white;

          if (viewModel.isBusy) {
            child = Center(
              child: CircularProgressIndicator(),
            );
          } else if (viewModel.file != null) {
            color = Color.fromARGB(255, 53, 38, 111);
            child = _buildImage(viewModel.file);
          } else {
            color = Color.fromARGB(255, 53, 38, 111);
            child = Container();
            viewModel.loadImageFileIfNeeded();
          }

          return ClipOval(
            child: Container(
              color: color,
              child: child,
              height: radius * 2.0,
              width: radius * 2.0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(File imageFile) {
    var fileExtension = path.extension(imageFile.path);
    switch (fileExtension) {
      case ".svg":
        return SvgPicture.file(imageFile);
      default:
        return Image.file(imageFile);
    }
  }
}
