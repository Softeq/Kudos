import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';

class GradientAppBar extends AppBar {
  GradientAppBar({String title, List<Widget> actions})
      : super(
          title: Text(title ?? ""),
          actions: actions,
          flexibleSpace: _buildGradientBackground(),
        );

  GradientAppBar.withWidget(Widget titleWidget, {List<Widget> actions})
      : super(
          title: titleWidget,
          actions: actions,
          flexibleSpace: _buildGradientBackground(),
        );

  static Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            KudosTheme.mainGradientStartColor,
            KudosTheme.mainGradientEndColor,
          ],
        ),
      ),
    );
  }
}
