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
            return _buildBusyWidget();
          } else if (imageViewModel.file == null &&
              (imageViewModel.imageUrl == null ||
                  imageViewModel.imageUrl.isEmpty)) {
            return _buildPlaceholderWidget();
          } else if (viewModel.file != null) {
            return _buildImageWidget();
          } else {
            viewModel.loadImageFileIfNeeded();
            return ClipOval(
              child: Container(
                width: size,
                height: size,
                color: imagePlaceholder.color,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBusyWidget() {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: imagePlaceholder.color,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderWidget() {
    return ClipOval(
      child: Container(
        width: size,
        height: size,
        color: imagePlaceholder.color,
        child: Center(
          child: Text(imagePlaceholder.abbreviation),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    var fileExtension = path.extension(imageViewModel.file.path);
    switch (fileExtension) {
      case ".svg":
        return ClipOval(
          child: Container(
            color: imagePlaceholder.color,
            child: SvgPicture.file(
              imageViewModel.file,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
      default:
        return ClipOval(
          child: Container(
            color: imagePlaceholder.color,
            child: Image.file(
              imageViewModel.file,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          ),
        );
    }
  }
}
