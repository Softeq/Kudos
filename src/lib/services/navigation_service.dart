import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/page_mapper_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:provider/provider.dart';

class NavigationService {
  final _pageMapperService = locator<PageMapperService>();

  final navigatorKey = GlobalKey<NavigatorState>();

  Future<TResult> navigateTo<TViewModel extends BaseViewModel, TResult>(
    TViewModel viewModel, {
    bool fullscreenDialog,
  }) {
    final route = _getRoute<TViewModel, TResult>(
      viewModel,
      fullscreenDialog: fullscreenDialog,
    );
    return navigatorKey.currentState.push(route);
  }

  void pop<T>([T result]) {
    navigatorKey.currentState.pop(result);
  }

  void replace<TViewModel extends BaseViewModel, TResult>(
    TViewModel viewModel,
  ) {
    navigatorKey.currentState.popUntil(ModalRoute.withName('/'));
    final route = _getRoute<TViewModel, void>(viewModel);
    navigatorKey.currentState.pushReplacement(route);
  }

  Widget getTab<TViewModel extends BaseViewModel>(
    TViewModel Function() createViewModel,
  ) {
    var tab = _pageMapperService.getTab<TViewModel>();
    var wrappedTab = ChangeNotifierProvider(
      create: (context) => createViewModel?.call(),
      child: tab,
    );
    return wrappedTab;
  }

  MaterialPageRoute<TResult>
      _getRoute<TViewModel extends BaseViewModel, TResult>(
    TViewModel viewModel, {
    bool fullscreenDialog,
  }) {
    final page = _pageMapperService.getPage<TViewModel>();
    final wrappedPage = ChangeNotifierProvider(
      create: (context) => viewModel,
      child: page,
    );
    final pageName = _pageMapperService.getPageName<TViewModel>();
    final route = _getMaterialPageRoute<TResult>(
      wrappedPage,
      pageName,
      fullscreenDialog: fullscreenDialog,
    );
    return route;
  }

  MaterialPageRoute<T> _getMaterialPageRoute<T>(
    Widget page,
    String pageName, {
    bool fullscreenDialog,
  }) {
    return MaterialPageRoute<T>(
      settings: RouteSettings(name: pageName),
      builder: (context) => page,
      fullscreenDialog: fullscreenDialog ?? false,
    );
  }

  PageRouteBuilder<T> _getPageRouteBuilder<T>(
    Widget page,
    String pageName, {
    bool fullscreenDialog,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: pageName),
      fullscreenDialog: fullscreenDialog ?? false,
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
