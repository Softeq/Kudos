import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kudosapp/generated/l10n.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/pages/home_page.dart';
import 'package:kudosapp/pages/login_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/analytics_service.dart';
import 'package:kudosapp/services/database/mandatory_update_database_service.dart';
import 'package:kudosapp/services/navigation_service.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/viewmodels/home_viewmodel.dart';
import 'package:provider/provider.dart';

class KudosApp extends StatelessWidget {
  final _analyticsService = locator<AnalyticsService>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _analyticsService.logAppOpened();

    return GetMaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: S().appName,
      color: KudosTheme.mainGradientStartColor,
      theme: ThemeData(
        accentColor: KudosTheme.accentColor,
        highlightColor: KudosTheme.highlightColor,
        splashColor: KudosTheme.splashColor,
        textSelectionColor: KudosTheme.accentColor.withAlpha(50),
        buttonTheme: ButtonThemeData(
          highlightColor: Colors.transparent,
          splashColor: KudosTheme.buttonSplashColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: KudosTheme.accentColor,
          foregroundColor: Colors.white,
          splashColor: KudosTheme.buttonSplashColor,
        ),
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ],
        child: Consumer<AuthViewModel>(
          builder: (context, viewModel, child) =>
              _buildHome(context, viewModel),
        ),
      ),
      navigatorObservers: [
        _analyticsService.observer,
      ],
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }

  Widget _buildHome(BuildContext context, AuthViewModel viewModel) {
    switch (viewModel.authState) {
      case AuthViewModelState.loggedIn:
        locator<MandatoryUpdateDatabaseService>().refreshSubscriptions();
        return ChangeNotifierProvider(
          create: (context) => HomeViewModel(context),
          child: HomePage(),
        );
      case AuthViewModelState.loggedOut:
        return LoginPage();
      case AuthViewModelState.unknown:
      default:
        return _buildLoading();
    }
  }

  Widget _buildLoading() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
