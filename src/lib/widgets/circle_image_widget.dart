import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/helpers/image_placeholder_builder.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class CircleImageWidget extends StatelessWidget {
  final ImageViewModel imageViewModel;
  final double size;
  final ImagePlaceholder imagePlaceholder;

  CircleImageWidget({
    this.imageViewModel,
    this.size,
    String name,
  }) : imagePlaceholder = ImagePlaceholderBuilder.build(name);

  CircleImageWidget.withUrl(String imageUrl, String name, [this.size])
      : imageViewModel = ImageViewModel()..initialize(imageUrl, null, false),
        imagePlaceholder = ImagePlaceholderBuilder.build(name);

  CircleImageWidget.withFile(File imageFile, String name, [this.size])
      : imageViewModel = ImageViewModel()..initialize(null, imageFile, false),
        imagePlaceholder = ImagePlaceholderBuilder.build(name);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageViewModel>.value(
      value: imageViewModel,
      child: Consumer<ImageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return getBusyWidget();
          } else if (imageViewModel.file == null &&
              (imageViewModel.imageUrl == null ||
                  imageViewModel.imageUrl.isEmpty)) {
            return getPlaceholderWidget();
          } else if (viewModel.file != null) {
            return getImageWidget();
          } else {
            viewModel.loadImageFileIfNeeded();
            return Container(height: size, width: size);
          }
        },
      ),
    );
  }

  Widget getBusyWidget() {
    return CircularProgressIndicator();
  }

  Widget getPlaceholderWidget() {
    return ClipOval(
        child: Container(
            width: size,
            height: size,
            color: imagePlaceholder.color,
            child: Center(child: Text(imagePlaceholder.abbreviation))));
  }

  Widget getImageWidget() {
    var fileExtension = path.extension(imageViewModel.file.path);
    switch (fileExtension) {
      case ".svg":
        return ClipOval(
            child: SvgPicture.file(imageViewModel.file,
                width: size, height: size, fit: BoxFit.cover));
      default:
        return ClipOval(
            child: Image.file(imageViewModel.file,
                width: size, height: size, fit: BoxFit.cover));
    }
  }
}
