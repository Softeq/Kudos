import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/sending_viewmodel.dart';
import 'package:kudosapp/viewmodels/people_viewmodel.dart';
import 'package:kudosapp/widgets/people_list_widget.dart';

class SendingRoute extends MaterialPageRoute {
  SendingRoute(Achievement achievement)
      : super(
          builder: (context) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => PeopleViewModel(
                  excludeCurrentUser: true,
                )),
                ChangeNotifierProvider(
                    create: (context) => SendingViewModel(achievement)),
              ],
              child: SendingPage(),
            );
          },
        );
}

class SendingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locator<LocalizationService>().send),
      ),
      body: Consumer<SendingViewModel>(
        builder: (context, viewModel, child) {
          return PeopleList(
            (user) => _sendAchievementToUser(context, viewModel, user),
            Icon(Icons.send),
          );
        },
      ),
    );
  }

  Future<void> _sendAchievementToUser(
      BuildContext context, SendingViewModel viewModel, User user) async {
    try {
      var commentText = await _putCommentDialog(context);

      if (commentText != null) {
        await viewModel.sendTo(user, commentText);

        _notifyAboutSuccess(context);
      }
    } catch (error) {
      _notifyAboutError(context, error);
    }
  }

  Future<String> _putCommentDialog(BuildContext context) async {
    final TextEditingController _inputController = TextEditingController();

    bool accepted = false;

    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _inputController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: locator<LocalizationService>().writeAComment,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(locator<LocalizationService>().cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(locator<LocalizationService>().send),
                onPressed: () {
                  accepted = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    return accepted ? _inputController.text : null;
  }

  void _notifyAboutSuccess(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
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
            locator<LocalizationService>().sentSuccessfully,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 4),
    ));
  }

  void _notifyAboutError(BuildContext context, error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        locator<LocalizationService>().generalErrorMessage,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: Theme.of(context).errorColor,
      duration: Duration(seconds: 4),
    ));
  }
}
