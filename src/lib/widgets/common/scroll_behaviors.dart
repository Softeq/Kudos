import 'package:flutter/material.dart';

/// Scroll Behavior that disables [GlowingOverscrollIndicator] for Android.
/// https://api.flutter.dev/flutter/widgets/ScrollBehavior/buildViewportChrome.html
class DisableGlowingOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(context, child, axisDirection) => child;
}
