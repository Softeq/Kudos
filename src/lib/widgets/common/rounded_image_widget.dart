import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kudosapp/helpers/colored_placeholder_builder.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:path/path.dart' as path;

class RoundedImageWidget extends StatefulWidget {
  final String _imageUrl;
  final String _title;
  final double _borderRadius;
  final double _size;
  final File _file;
  final Color _placeholderColor;
  final bool _addHeroAnimation;

  RoundedImageWidget._(
    this._imageUrl,
    this._title,
    this._borderRadius,
    this._size,
    this._file,
    this._placeholderColor,
    this._addHeroAnimation,
  );

  factory RoundedImageWidget.circular({
    @required double size,
    String imageUrl,
    String title,
    File file,
    Color placeholderColor,
    bool addHeroAnimation,
  }) {
    return RoundedImageWidget._(
      imageUrl,
      title,
      size / 2.0,
      size,
      file,
      placeholderColor,
      addHeroAnimation,
    );
  }

  factory RoundedImageWidget.square({
    @required double size,
    @required double borderRadius,
    String imageUrl,
    String title,
    File file,
    Color placeholderColor,
    bool addHeroAnimation,
  }) {
    return RoundedImageWidget._(
      imageUrl,
      title,
      borderRadius,
      size,
      file,
      placeholderColor,
      addHeroAnimation,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _RoundedImageWidgetState();
  }
}

class _RoundedImageWidgetState extends State<RoundedImageWidget> {
  String _url;
  File _file;
  ColoredPlaceholder _coloredPlaceholder;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_url != widget._imageUrl) {
      _file = null;
      _url = widget._imageUrl;
    }

    if (widget._file != null) {
      _file = widget._file;
    }

    if (_file == null) {
      _loadImageFromMemory();
    }

    if (_file != null) {
      return _buildImageWidget();
    } else {
      _loadImage();
      return _buildPlaceholderWidget();
    }
  }

  void _loadImageFromMemory() {
    if (_url?.isNotEmpty ?? false) {
      var fileInfo = DefaultCacheManager().getFileFromMemory(_url);
      if (fileInfo?.file != null) {
        if (!_isDisposed) {
          _file = fileInfo.file;
        }
      }
    }
  }

  Future<void> _loadImage() async {
    if (_url?.isNotEmpty ?? false) {
      var newFile = await DefaultCacheManager().getSingleFile(_url);
      if (newFile != null) {
        if (!_isDisposed) {
          setState(() {
            _file = newFile;
          });
        }
      }
    }
  }

  Widget _buildPlaceholderWidget() {
    if (widget._title != null) {
      _coloredPlaceholder = ColoredPlaceholderBuilder.build(widget._title);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget._borderRadius),
      child: _coloredPlaceholder == null
          ? Container(
              width: widget._size,
              height: widget._size,
              color: widget._placeholderColor ??
                  Color.fromRGBO(238, 238, 238, 1.0),
              child: Center(
                child: Container(
                  width: widget._size * 0.6,
                  height: widget._size * 0.6,
                  child: SvgPicture.asset("assets/icons/image_placeholder.svg"),
                ),
              ),
            )
          : Container(
              width: widget._size,
              height: widget._size,
              color: _coloredPlaceholder.color,
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Text(
                    _coloredPlaceholder.abbreviation,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: KudosTheme.textColor,
                      fontSize: widget._size / 3.0,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildImageWidget() {
    var fileExtension = path.extension(_file.path);

    Widget imageWidget;
    switch (fileExtension) {
      case ".svg":
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(widget._borderRadius),
          child: Container(
            child: SvgPicture.file(
              _file,
              width: widget._size,
              height: widget._size,
              fit: BoxFit.cover,
            ),
          ),
        );
        break;
      default:
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(widget._borderRadius),
          child: Container(
            child: Image.file(
              _file,
              width: widget._size,
              height: widget._size,
              fit: BoxFit.cover,
            ),
          ),
        );
    }

    return ((widget._addHeroAnimation ?? false) && (widget._imageUrl != null))
        ? Hero(child: imageWidget, tag: widget._imageUrl)
        : imageWidget;
  }
}
