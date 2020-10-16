import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';

class SliverGradientAppBar extends SliverAppBar {
  SliverGradientAppBar({
    BuildContext context,
    String title,
    String imageUrl,
    bool useTitleForPlaceholder = false,
    List<Widget> actions,
    double elevation,
    String heroTag,
  }) : super(
          backgroundColor: Colors.transparent,
          expandedHeight: KudosTheme.expandedSliverAppBarHeight,
          floating: false,
          pinned: true,
          elevation: elevation,
          actions: actions,
          flexibleSpace: heroTag == null
              ? _buildFlexibleSpace(
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      title ?? "",
                      style: KudosTheme.appBarTitleTextStyle,
                    ),
                  ),
                  _buildAppBarImage(
                    context,
                    imageUrl,
                    useTitleForPlaceholder ? title : null,
                  ))
              : _buildAnimatedFlexibleSpace(
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      title ?? "",
                      style: KudosTheme.appBarTitleTextStyle,
                    ),
                  ),
                  _buildAppBarImage(
                    context,
                    imageUrl,
                    useTitleForPlaceholder ? title : null,
                  ),
                  heroTag),
        );

  SliverGradientAppBar.withTitleWidget({
    BuildContext context,
    Widget titleWidget,
    String imageUrl,
    List<Widget> actions,
    double elevation,
    String heroTag,
  }) : super(
          backgroundColor: Colors.transparent,
          expandedHeight: KudosTheme.expandedSliverAppBarHeight,
          floating: false,
          pinned: true,
          elevation: elevation,
          actions: actions,
          flexibleSpace: heroTag == null
              ? _buildFlexibleSpace(
                  titleWidget,
                  _buildAppBarImage(context, imageUrl, null),
                )
              : _buildAnimatedFlexibleSpace(
                  titleWidget,
                  _buildAppBarImage(context, imageUrl, null),
                  heroTag,
                ),
        );

  static Widget _buildAnimatedFlexibleSpace(
    Widget titleWidget,
    Widget imageWidget,
    String heroTag,
  ) {
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
        child: FlexibleSpaceBar.createSettings(
          currentExtent: 0,
          child: _buildHeaderBackground(imageWidget, titleWidget),
        ),
      ),
    );
  }

  static Widget _buildFlexibleSpace(Widget titleWidget, Widget imageWidget) {
    return Container(
      decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
      child: FlexibleSpaceBar(
        centerTitle: true,
        title: titleWidget,
        background: _buildHeaderBackground(imageWidget),
      ),
    );
  }

  static Widget _buildHeaderBackground(Widget imageWidget,
      [Widget titleWidget]) {
    var children = <Widget>[
      imageWidget,
      Container(
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.black.withAlpha(60),
              Colors.transparent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Colors.black.withAlpha(60),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
      ),
    ];

    if (titleWidget != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: titleWidget,
          ),
        ),
      );
    }
    return Stack(children: children);
  }

  static Widget _buildAppBarImage(
    BuildContext context,
    String imageUrl,
    String title,
  ) {
    var size = max(
      MediaQuery.of(context).size.width,
      KudosTheme.expandedSliverAppBarHeight +
          MediaQuery.of(context).padding.top,
    );
    return Center(
      child: RoundedImageWidget.square(
        imageUrl: imageUrl,
        size: size,
        borderRadius: 0,
        title: title,
      ),
    );
  }
}
