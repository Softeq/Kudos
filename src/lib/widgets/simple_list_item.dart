import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/counter_widget.dart';

class ImageShape {
  final double cornerRadius;
  final double size;
  final bool isCircle;
  final bool isSquare;

  ImageShape.square(this.size, this.cornerRadius)
      : isSquare = true,
        isCircle = false;
  ImageShape.circle(this.size)
      : cornerRadius = 0,
        isSquare = false,
        isCircle = true;
}

class SimpleListItem extends StatelessWidget {
  static const double _imagePadding = 16;
  static const double _selectorIconPadding = 16;

  final void Function() onTap;
  final String title;
  final String description;
  final ImageViewModel imageViewModel;
  final String imageUrl;
  final int imageCounter;
  final Widget selectorIcon;
  final ImageShape imageShape;

  SimpleListItem(
      {this.onTap,
      this.title,
      this.description,
      this.imageUrl,
      this.imageViewModel,
      this.imageCounter,
      this.selectorIcon,
      this.imageShape});

  @override
  Widget build(BuildContext context) {
    Widget item = Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(top: 8),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildImageWidget(),
              _buildTextWidget(),
              _buildSelectorWidget(),
            ],
          ),
          _buildSeparator(),
        ],
      ),
    );

    if (onTap != null) {
      item = Material(
          color: Colors.transparent,
          child: InkWell(
            child: item,
            onTap: onTap,
          ));
    }
    return item;
  }

  Widget _buildSeparator() {
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
        // bottom: 8.0,
        left: imageShape == null ? 0 : (imageShape.size + _imagePadding * 2),
      ),
      height: 1.0,
      color: KudosTheme.accentColor,
    );
  }

  Widget _buildSelectorWidget() {
    return Padding(
      padding: EdgeInsets.only(right: _selectorIconPadding),
      child: selectorIcon,
    );
  }

  Widget _buildTextWidget() {
    Widget widget;

    if (title != null && description != null) {
      widget = Padding(
        padding: EdgeInsets.only(bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 8.0),
            Text(
              title,
              style: KudosTheme.listTitleTextStyle,
            ),
            SizedBox(height: 6.0),
            Text(
              description,
              style: KudosTheme.listSubTitleTextStyle,
            ),
          ],
        ),
      );
    } else if (title != null || description != null) {
      widget = Text(
        title ?? description,
        style: KudosTheme.listTitleTextStyle,
      );
    } else {
      widget = Container();
    }
    return Expanded(child: widget);
  }

  Widget _buildImageFromUrl() {
    var imageProvider = CachedNetworkImageProvider(imageUrl);
    if (imageShape.isCircle) {
      return CircleAvatar(
        radius: imageShape.size / 2,
        backgroundImage: imageProvider,
      );
    } else {
      return Image(
        width: imageShape.size,
        height: imageShape.size,
        image: imageProvider,
      );
    }
  }

  Widget _buildImageFromViewModel() {
    if (imageShape.isCircle) {
      return RoundedImageWidget.circular(
        imageViewModel: imageViewModel,
        size: imageShape.size,
        name: title,
      );
    } else {
      return RoundedImageWidget.square(
        imageViewModel: imageViewModel,
        name: title,
        size: imageShape.size,
        borderRadius: imageShape.cornerRadius,
      );
    }
  }

  Widget _buildImageWidget() {
    if (imageUrl != null || imageViewModel != null) {
      Widget imageContent;
      if (imageUrl != null) {
        imageContent = Center(child: _buildImageFromUrl());
      } else if (imageViewModel != null) {
        imageContent = Center(child: _buildImageFromViewModel());

        if (imageCounter != null && imageCounter > 1) {
          return Container(
            width: imageShape.size + _imagePadding * 2,
            child: Stack(
              children: <Widget>[
                imageContent,
                Positioned(
                  bottom: 0.0,
                  right: 8.0,
                  child: CounterWidget(
                    count: imageCounter,
                    height: 40.0,
                  ),
                ),
              ],
            ),
          );
        }
      }
      return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _imagePadding,
          ),
          child: imageContent);
    } else {
      return SizedBox(
          height: imageShape?.size ?? 0, width: imageShape?.size ?? 0);
    }
  }
}
