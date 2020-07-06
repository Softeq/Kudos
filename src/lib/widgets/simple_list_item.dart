import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/kudos_theme.dart';
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
  final String imageUrl;
  final int imageCounter;
  final Widget selectorIcon;
  final ImageShape imageShape;
  final Widget contentWidget;
  final bool useTextPlaceholder;
  final bool addHeroAnimation;

  SimpleListItem({
    this.onTap,
    this.title,
    this.description,
    this.imageUrl,
    this.imageCounter,
    this.selectorIcon,
    this.imageShape,
    this.contentWidget,
    this.useTextPlaceholder,
    this.addHeroAnimation,
  });

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
          _buildContentWidget(),
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
        ),
      );
    }
    return item;
  }

  Widget _buildContentWidget() {
    return contentWidget != null
        ? Container(
            margin: EdgeInsets.only(
              top: 8.0,
              left: imageShape == null
                  ? 0
                  : (imageShape.size + _imagePadding * 2),
            ),
            child: contentWidget,
          )
        : Container();
  }

  Widget _buildSeparator() {
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
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
    if (imageShape.isCircle) {
      return RoundedImageWidget.circular(
        imageUrl: imageUrl,
        size: imageShape.size,
        title: useTextPlaceholder ? title : null,
        addHeroAnimation: addHeroAnimation,
      );
    } else {
      return RoundedImageWidget.square(
        imageUrl: imageUrl,
        size: imageShape.size,
        borderRadius: imageShape.cornerRadius,
        title: useTextPlaceholder ? title : null,
        addHeroAnimation: addHeroAnimation,
      );
    }
  }

  Widget _buildImageWidget() {
    if (imageUrl != null || useTextPlaceholder) {
      final imageContent = Center(
        child: _buildImageFromUrl(),
      );
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

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: _imagePadding,
        ),
        child: imageContent,
      );
    } else {
      return SizedBox(
        height: imageShape?.size ?? 0,
        width: imageShape?.size ?? 0,
      );
    }
  }
}
