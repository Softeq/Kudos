import 'package:flutter/material.dart';
import 'package:kudosapp/models/errors/auth_error.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/widgets/snack_bar_notifier.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/login_viewmodel.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final SnackBarNotifier _snackBarNotifier = SnackBarNotifier();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AuthViewModel, LoginViewModel>(
      create: (context) => null,
      update: (context, authViewModel, _) {
        return LoginViewModel(authViewModel);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizer().appName),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                localizer().notSignedIn,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              viewModel.isBusy
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.blue,
                      child: Text(
                        localizer().signIn,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => _signIn(context, viewModel),
                    ),
            ],
          );
        },
      ),
    );
  }

  void _signIn(BuildContext context, LoginViewModel viewModel) async {
    try {
      await viewModel.signIn();
    } on AuthError catch (error) {
      final internalMessage = (error.internalError as AuthError)?.message;
      _snackBarNotifier.showErrorMessage(context, Scaffold.of(context), '${error.message}: $internalMessage');
    }
  }
}
