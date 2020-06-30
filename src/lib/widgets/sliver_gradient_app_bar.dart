import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';

class SliverGradientAppBar extends SliverAppBar {
  SliverGradientAppBar({
    String title,
    Widget imageWidget,
    List<Widget> actions,
    double elevation,
    String heroTag,
  }) : super(
          backgroundColor: Colors.transparent,
          expandedHeight: 350.0,
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
                  imageWidget)
              : _buildAnimatedFlexibleSpace(
                  Material(
                    type: MaterialType.transparency,
                    child: Text(
                      title ?? "",
                      style: KudosTheme.appBarTitleTextStyle,
                    ),
                  ),
                  imageWidget,
                  heroTag),
        );

  SliverGradientAppBar.withTitleWidget({
    Widget titleWidget,
    Widget imageWidget,
    List<Widget> actions,
    double elevation,
    String heroTag,
  }) : super(
          backgroundColor: Colors.transparent,
          expandedHeight: 350.0,
          floating: false,
          pinned: true,
          elevation: elevation,
          actions: actions,
          flexibleSpace: heroTag == null
              ? _buildFlexibleSpace(titleWidget, imageWidget)
              : _buildAnimatedFlexibleSpace(titleWidget, imageWidget, heroTag),
        );

  static Widget _buildAnimatedFlexibleSpace(
      Widget titleWidget, Widget imageWidget, String heroTag) {
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
        child: FlexibleSpaceBar.createSettings(
            currentExtent: 0,
            child: _buildHeaderBackground(imageWidget, titleWidget)),
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
          child: Align(alignment: Alignment.bottomCenter, child: titleWidget),
        ),
      );
    }
    return Stack(children: children);
  }
}
