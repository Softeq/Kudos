import 'package:flutter/material.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/services/auth.dart';
import 'package:kudosapp/services/google_api.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();
  final GoogleApiService _apiService = GoogleApiService();

  User _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();

    _auth.silentInit((user) async {
      setState(() {
        _currentUser = user;
      });

      if (_currentUser != null) {
        _handleGetContact();
      }
    });
  }

  Future<void> _handleGetContact() async {
    await _apiService.getContact(_auth, (text) {
      setState(() {
        _contactText = text;
      });
    });
  }

  Widget _buildBody() {
    if (_currentUser != null) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: _auth.avatarView,
            title: Text(_currentUser.name ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: _auth.signOut,
            ),
          ),
          const Text("Signed in successfully."),
          Text(_contactText ?? ''),
          RaisedButton(
            child: const Text('REFRESH'),
            onPressed: _handleGetContact,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text("You are not currently signed in."),
          RaisedButton(
            child: const Text('SIGN IN'),
            onPressed: _auth.signIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kudos'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: _buildBody(),
      ),
    );
  }
}
