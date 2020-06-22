import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/helpers/image_placeholder_builder.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class RoundedImageWidget extends StatelessWidget {
  final ImageViewModel _imageViewModel;
  final double _size;
  final double _borderRadius;
  final ImagePlaceholder _imagePlaceholder;

  RoundedImageWidget._(
    this._imageViewModel,
    this._size,
    this._borderRadius,
    String _name,
  ) : _imagePlaceholder = ImagePlaceholderBuilder.build(_name);

  factory RoundedImageWidget.circular({
    @required ImageViewModel imageViewModel,
    @required double size,
    String name = "",
  }) {
    return RoundedImageWidget._(imageViewModel, size, size / 2.0, name);
  }

  factory RoundedImageWidget.square({
    @required ImageViewModel imageViewModel,
    @required double size,
    @required double borderRadius,
    String name = "",
  }) {
    return RoundedImageWidget._(imageViewModel, size, borderRadius, name);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ImageViewModel>.value(
      value: _imageViewModel,
      child: Consumer<ImageViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
            return _buildBusyWidget();
          } else if (_imageViewModel.file == null &&
              (_imageViewModel.imageUrl == null ||
                  _imageViewModel.imageUrl.isEmpty)) {
            return _buildPlaceholderWidget();
          } else if (viewModel.file != null) {
            return _buildImageWidget();
          } else {
            viewModel.loadImageFileIfNeeded();
            return _buildPlaceholderWidget();
          }
        },
      ),
    );
  }

  Widget _buildBusyWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        width: _size,
        height: _size,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildPlaceholderWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        width: _size,
        height: _size,
        color: _imagePlaceholder.color,
        child: Center(
          child: Text(
            _imagePlaceholder.abbreviation,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: KudosTheme.textColor,
              fontSize: _size / 3.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    var fileExtension = path.extension(_imageViewModel.file.path);
    switch (fileExtension) {
      case ".svg":
        return ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Container(
            child: SvgPicture.file(
              _imageViewModel.file,
              width: _size,
              height: _size,
              fit: BoxFit.cover,
            ),
          ),
        );
      default:
        return ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: Container(
            child: Image.file(
              _imageViewModel.file,
              width: _size,
              height: _size,
              fit: BoxFit.cover,
            ),
          ),
        );
    }
  }
}
