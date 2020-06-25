import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';

class SliverGradientAppBar extends SliverAppBar {
  SliverGradientAppBar(
      {String title,
      Widget imageWidget,
      List<Widget> actions,
      double elevation})
      : super(
          expandedHeight: 350.0,
          floating: false,
          pinned: true,
          elevation: elevation,
          actions: actions,
          flexibleSpace: _buildFlexibleSpace(
              Text(
                title ?? "",
                style: KudosTheme.appBarTitleTextStyle,
              ),
              imageWidget),
        );

  SliverGradientAppBar.withTitleWidget(
      {Widget titleWidget,
      Widget imageWidget,
      List<Widget> actions,
      double elevation})
      : super(
          expandedHeight: 350.0,
          floating: false,
          pinned: true,
          elevation: elevation,
          actions: actions,
          flexibleSpace: _buildFlexibleSpace(titleWidget, imageWidget),
        );

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

  static Widget _buildHeaderBackground(Widget imageWidget) {
    return Stack(children: <Widget>[
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
          ))),
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
              ))))
    ]);
  }
}
