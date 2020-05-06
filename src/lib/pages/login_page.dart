import 'package:flutter/material.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.appName),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('You are not currently signed in.'),  // TODO YP: UI not final
            RaisedButton(
              child: Text('SIGN IN'),
              onPressed: authViewModel.signIn,
            ),
          ],
        ),
      ),
    );
  }
}
