import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kudosapp/generated/l10n.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/login_page.dart';
import 'package:kudosapp/pages/home_page.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';

class KudosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) => GetMaterialApp(
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: S().appName,
          theme: ThemeData(
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: KudosTheme.accentColor,
            ),
          ),
          home: _buildHome(viewModel),
        ),
      ),
    );
  }

  Widget _buildHome(AuthViewModel viewModel) {
    switch (viewModel.authState) {
      case AuthViewModelState.loggedIn:
        return HomePage();
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
