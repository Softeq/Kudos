import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';

class DialogsService {
  Future<void> showOneButtonDialog({
    @required BuildContext context,
    @required String title,
    @required String content,
    @required String buttonTitle,
    Color buttonColor,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: title == null ? null : Text(title),
              content: content == null ? null : Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(buttonTitle,
                      style: TextStyle(
                        color: buttonColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<bool> showTwoButtonsDialog({
    @required BuildContext context,
    @required String title,
    @required String content,
    @required String firstButtonTitle,
    @required String secondButtonTitle,
    Color firstButtonColor,
    Color secondButtonColor,
  }) async {
    bool firstButton = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: title == null ? null : Text(title),
              content: content == null ? null : Text(content),
              actions: <Widget>[
                FlatButton(
                    child: Text(firstButtonTitle,
                        style: TextStyle(
                          color: firstButtonColor,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      firstButton = true;
                    }),
                FlatButton(
                    child: Text(
                      secondButtonTitle,
                      style: TextStyle(
                        color: secondButtonColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      firstButton = false;
                    })
              ],
            ));
    return firstButton;
  }

  Future<void> showOkDialog({
    @required BuildContext context,
    String title,
    String content,
  }) {
    return showOneButtonDialog(
        context: context,
        title: title,
        content: content,
        buttonTitle: localizer().ok);
  }

  Future<bool> showOkCancelDialog({
    @required BuildContext context,
    String title,
    String content,
  }) {
    return showTwoButtonsDialog(
        context: context,
        title: title,
        content: content,
        firstButtonTitle: localizer().ok,
        secondButtonTitle: localizer().cancel);
  }

  Future<bool> showDeleteCancelDialog({
    @required BuildContext context,
    String title,
    String content,
  }) {
    return showTwoButtonsDialog(
        context: context,
        title: title,
        content: content,
        firstButtonTitle: localizer().delete,
        secondButtonTitle: localizer().cancel,
        firstButtonColor: Color.fromARGB(255, 255, 59, 48));
  }
}
