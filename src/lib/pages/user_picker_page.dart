import 'package:flutter/material.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/user_picker_viewmodel.dart';
import 'package:kudosapp/widgets/list_of_people_widget.dart';
import 'package:provider/provider.dart';

class UserPickerRoute extends MaterialPageRoute<List<User>> {
  UserPickerRoute({bool allowMultipleSelection = false, List<String> userIds})
      : super(
          builder: (context) {
            return ChangeNotifierProvider<UserPickerViewModel>(
              create: (context) {
                return UserPickerViewModel()..initialize(userIds);
              },
              child: _UserPickerPage(allowMultipleSelection),
            );
          },
          fullscreenDialog: true,
        );
}

class _UserPickerPage extends StatefulWidget {
  final _allowMultipleSelection;

  _UserPickerPage(this._allowMultipleSelection);

  @override
  State<StatefulWidget> createState() {
    return _UserPickerPageState();
  }
}

class _UserPickerPageState extends State<_UserPickerPage> {
  final _textEditingController = TextEditingController();
  final _localizationService = locator<LocalizationService>();

  @override
  Widget build(BuildContext context) {
    var actions = List<Widget>();
    if (widget._allowMultipleSelection) {
      actions.add(
        IconButton(
          onPressed: () {
            var viewModel = Provider.of<UserPickerViewModel>(
              context,
              listen: false,
            );
            Navigator.of(context).pop(viewModel.selectedUsers);
          },
          icon: Icon(Icons.done),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          controller: _textEditingController,
          decoration: InputDecoration(hintText: _localizationService.addPeople),
          onChanged: (x) {
            var viewModel = Provider.of<UserPickerViewModel>(
              context,
              listen: false,
            );
            viewModel.addToQueue(x);
          },
        ),
        actions: actions,
      ),
      body: Consumer<UserPickerViewModel>(
        builder: (context, viewModel, child) {
          switch (viewModel.state) {
            case UserPickerViewModelState.initialState:
              return Container();
            case UserPickerViewModelState.searchResults:
              if (viewModel.users.isEmpty) {
                return Container();
              }
              return ListOfPeopleWidget(
                itemSelector: (x) {
                  if (widget._allowMultipleSelection) {
                    _textEditingController.text = "";
                    viewModel.select(x);
                  } else {
                    Navigator.of(context).pop([x]);
                  }
                },
                users: viewModel.users,
              );
            case UserPickerViewModelState.selectedUsers:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: 20.0,
                      left: 72.0,
                    ),
                    child: Text(
                      _localizationService.addedPeople.toUpperCase(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Expanded(
                    child: ListOfPeopleWidget(
                      trailingWidget: Icon(Icons.clear),
                      users: viewModel.selectedUsers,
                      trailingSelector: (x) {
                        viewModel.unselect(x);
                      },
                    ),
                  ),
                ],
              );
            default:
              return Container();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
