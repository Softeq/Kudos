import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kudosapp/generated/locale_keys.g.dart';
import 'package:kudosapp/core/errors/auth_error.dart';
import 'package:kudosapp/viewmodels/login_viewmodel.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AuthViewModel, LoginViewModel>(
      create: (context) => null,
      update: (context, authViewModel, _) {
        return LoginViewModel(authViewModel);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.appName.tr()),
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
                "You are not currently signed in.", // TODO YP: UI not final
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
                        LocaleKeys.signIn.tr(),
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
      _showNotification(context, '${error.message}: $internalMessage');
    }
  }

  void _showNotification(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
