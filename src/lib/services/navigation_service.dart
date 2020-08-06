import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:provider/provider.dart';

class NavigationService {
  void pop<T>(BuildContext context, [T result]) =>
      Navigator.of(context).pop(result);

  Future<T> navigateTo<T>(BuildContext context, Widget page) =>
      Navigator.of(context).push(_getMaterialPageRoute(page));

  Future<TResult>
      navigateToViewModel<TViewModel extends BaseViewModel, TResult>(
    BuildContext context,
    Widget page,
    TViewModel viewModel,
  ) {
    var wrappedPage = ChangeNotifierProvider<TViewModel>(
      create: (context) => viewModel,
      child: page,
    );
    return navigateTo(context, wrappedPage);
  }

  MaterialPageRoute<T> _getMaterialPageRoute<T>(Widget page) {
    return MaterialPageRoute(
      builder: (context) => page,
      fullscreenDialog: true,
    );
  }

  PageRouteBuilder<T> _getPageRouteBuilder<T>(Widget page) {
    return PageRouteBuilder(
      fullscreenDialog: true,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          _getFadeTransition(animation, child),
    );
  }

  Widget _getFadeTransition(Animation<double> animation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  Widget _getSlideTransition(Animation<double> animation, Widget child) {
    var begin = Offset(0.0, 1.0);
    var end = Offset.zero;
    var curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}