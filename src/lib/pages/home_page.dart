import 'package:flutter/material.dart';
import 'package:kudosapp/pages/my_home_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              child: Text("navigate to my_home_page"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return MyHomePage();
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
