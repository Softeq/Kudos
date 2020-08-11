import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';

class DialogService {
  Future<void> showOneButtonDialog({
    @required BuildContext context,
    @required String title,
    @required String content,
    @required String buttonTitle,
    Color buttonColor,
  }) {
    buttonColor = buttonColor ?? KudosTheme.mainGradientStartColor;
    return showDialog(
        routeSettings: RouteSettings(name: "1-button Dialog"),
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
                  splashColor: buttonColor.withAlpha(30),
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
    firstButtonColor = firstButtonColor ?? KudosTheme.mainGradientStartColor;
    secondButtonColor = secondButtonColor ?? KudosTheme.mainGradientStartColor;
    await showDialog(
        routeSettings: RouteSettings(name: "2-buttons Dialog"),
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
                    splashColor: firstButtonColor.withAlpha(30),
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
                    splashColor: secondButtonColor.withAlpha(30),
                    onPressed: () {
                      Navigator.of(context).pop();
                      firstButton = false;
                    })
              ],
            ));
    return firstButton;
  }

  Future<int> showThreeButtonsDialog({
    @required BuildContext context,
    @required String title,
    @required String content,
    @required String firstButtonTitle,
    @required String secondButtonTitle,
    @required String thirdButtonTitle,
    Color firstButtonColor,
    Color secondButtonColor,
    Color thirdButtonColor,
  }) async {
    int result = 0;
    firstButtonColor = firstButtonColor ?? KudosTheme.mainGradientStartColor;
    secondButtonColor = secondButtonColor ?? KudosTheme.mainGradientStartColor;
    thirdButtonColor = thirdButtonColor ?? KudosTheme.mainGradientStartColor;
    await showDialog(
        routeSettings: RouteSettings(name: "3-buttons Dialog"),
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: title == null ? null : Text(title),
              content: content == null ? null : Text(content),
              actions: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                        child: Text(firstButtonTitle,
                            style: TextStyle(
                              color: firstButtonColor,
                            )),
                        splashColor: firstButtonColor.withAlpha(30),
                        onPressed: () {
                          Navigator.of(context).pop();
                          result = 1;
                        })),
                FlatButton(
                    child: Text(
                      secondButtonTitle,
                      style: TextStyle(
                        color: secondButtonColor,
                      ),
                    ),
                    splashColor: secondButtonColor.withAlpha(30),
                    onPressed: () {
                      Navigator.of(context).pop();
                      result = 2;
                    }),
                FlatButton(
                    child: Text(
                      thirdButtonTitle,
                      style: TextStyle(
                        color: thirdButtonColor,
                      ),
                    ),
                    splashColor: thirdButtonColor.withAlpha(30),
                    onPressed: () {
                      Navigator.of(context).pop();
                      result = 3;
                    })
              ],
            ));
    return result;
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
        firstButtonColor: KudosTheme.destructiveButtonColor);
  }

  Future<String> showCommentDialog({@required BuildContext context}) async {
    bool accepted = false;
    var inputController = new TextEditingController();

    await showDialog<String>(
      routeSettings: RouteSettings(name: "Comment Dialog"),
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: inputController,
            autofocus: true,
            style: KudosTheme.descriptionTextStyle,
            cursorColor: KudosTheme.accentColor,
            decoration: InputDecoration(
              labelText: localizer().writeAComment,
              labelStyle: TextStyle(
                color: KudosTheme.mainGradientEndColor,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: KudosTheme.accentColor),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                localizer().cancel,
                style: TextStyle(
                  color: KudosTheme.mainGradientStartColor,
                ),
              ),
              splashColor: KudosTheme.mainGradientStartColor.withAlpha(30),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                localizer().send,
                style: TextStyle(
                  color: KudosTheme.mainGradientStartColor,
                ),
              ),
              splashColor: KudosTheme.mainGradientStartColor.withAlpha(30),
              onPressed: () {
                accepted = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    var result = accepted ? inputController.text : null;
    inputController.dispose();
    return result;
  }
}
