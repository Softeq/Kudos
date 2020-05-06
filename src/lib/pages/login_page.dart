import 'package:flutter/material.dart';
import 'package:kudosapp/core/errors/auth_error.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {

  void _showNotification(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  void _signIn(BuildContext context) async {
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.signIn();

    } on AuthError catch (error) {
      final internalMessage = (error.internalError as AuthError)?.message;
      _showNotification(context, '${error.message}: $internalMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().appName),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'You are not currently signed in.', // TODO YP: UI not final
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Builder(
              builder: (ctx) => RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: Colors.blue,
                child: Text(
                  locator<LocalizationService>().signIn,
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.white
                  ),
                ),
                onPressed: () => _signIn(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
