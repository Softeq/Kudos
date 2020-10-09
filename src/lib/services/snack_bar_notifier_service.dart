import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';

class SnackBarNotifierService {
  void showErrorMessage(
    BuildContext context,
    ScaffoldState scaffoldState,
    String message,
  ) {
    scaffoldState.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }

  void showSuccessMessage(
    BuildContext context,
    ScaffoldState scaffoldState,
    String message,
  ) {
    scaffoldState.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "👍",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
  }

  void showGeneralErrorMessage(
    BuildContext context,
    ScaffoldState scaffoldState,
  ) {
    showErrorMessage(context, scaffoldState, localizer().generalErrorMessage);
  }
}
