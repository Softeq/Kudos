import 'package:flutter/material.dart';
import 'package:kudosapp/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/pages/home_page.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/service_locator.dart';

class KudosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) => MaterialApp(
          title: locator<LocalizationService>().appName,
          theme: ThemeData(),
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
