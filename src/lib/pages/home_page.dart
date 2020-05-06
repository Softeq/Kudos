import 'package:flutter/material.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationService.appName),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(authViewModel.currentUser.photoUrl),
            ),
            title: Text(authViewModel.currentUser.name ?? ''),
            subtitle: Text(authViewModel.currentUser.email ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: authViewModel.signOut,
            ),
          ),
          Text('Signed in successfully.'), // TODO YP: UI not final
        ],
      ),
    );
  }
}
