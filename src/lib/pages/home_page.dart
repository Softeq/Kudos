import 'package:flutter/material.dart';
import 'package:kudosapp/providers/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            ListTile(
              //leading: auth.avatarView,
              title: Text(auth.currentUser.name ?? ''),
              subtitle: Text(auth.currentUser.email ?? ''),
              trailing: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: auth.signOut,
              ),
            ),
            const Text("Signed in successfully."),
          ],
        ),
      ),
    );
  }
}
