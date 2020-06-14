import 'package:flutter/material.dart';
import 'package:kudosapp/service_locator.dart';

class DialogsService {
  Future<void> showOneButtonDialog(
      {@required BuildContext context,
      @required String title,
      @required String content,
      Function() onButtonPressed,
      String buttonTitle,
      Color buttonColor}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(buttonTitle ?? localizer().ok,
                      style: TextStyle(
                        color: buttonColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onButtonPressed?.call();
                  },
                )
              ],
            ));
  }

  Future<bool> showTwoButtonsDialog(
      {@required BuildContext context,
      @required String title,
      @required String content,
      @required String firstButtonTitle,
      @required String secondButtonTitle,
      Function() onFirstButtonPressed,
      Function() onSecondButtonPressed,
      Color firstButtonColor,
      Color secondButtonColor}) async {
    bool firstButton = false;
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                FlatButton(
                    child: Text(firstButtonTitle,
                        style: TextStyle(
                          color: firstButtonColor,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onFirstButtonPressed?.call();
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
                      onSecondButtonPressed?.call();
                      firstButton = false;
                    })
              ],
            ));
    return firstButton;
  }

  Future<bool> buildOkCancelDialog(
      {@required BuildContext context,
      @required String title,
      @required String content}) {
    return showTwoButtonsDialog(
        context: context,
        title: title,
        content: content,
        firstButtonTitle: localizer().ok,
        secondButtonTitle: localizer().cancel);
  }

  Future<bool> showDeleteCancelDialog(
      {@required BuildContext context,
      @required String title,
      @required String content}) {
    return showTwoButtonsDialog(
        context: context,
        title: title,
        content: content,
        firstButtonTitle: localizer().delete,
        secondButtonTitle: localizer().cancel,
        firstButtonColor: Color.fromARGB(255, 255, 59, 48));
  }
}
