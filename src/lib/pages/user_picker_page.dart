import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/user_picker_viewmodel.dart';
import 'package:kudosapp/widgets/list_of_people_widget.dart';

class UserPickerRoute extends MaterialPageRoute<List<User>> {
  UserPickerRoute({
    @required bool allowMultipleSelection,
    @required bool allowCurrentUser,
    List<String> selectedUserIds,
    WidgetBuilder trailingBuilder,
  }) : super(
          builder: (context) {
            return ChangeNotifierProvider<UserPickerViewModel>(
              create: (context) {
                return UserPickerViewModel()
                  ..initialize(
                    selectedUserIds,
                    allowCurrentUser,
                  );
              },
              child: _UserPickerPage(allowMultipleSelection, trailingBuilder),
            );
          },
          fullscreenDialog: true,
        );
}

class _UserPickerPage extends StatefulWidget {
  final bool _allowMultipleSelection;
  final WidgetBuilder _trailingBuilder;

  _UserPickerPage(this._allowMultipleSelection, this._trailingBuilder);

  @override
  State<StatefulWidget> createState() {
    return _UserPickerPageState();
  }
}

class _UserPickerPageState extends State<_UserPickerPage> {
  final _textEditingController = TextEditingController();

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
          decoration: InputDecoration.collapsed(
            hintText: localizer().addPeople,
          ),
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
                trailingWidget: widget._trailingBuilder == null
                    ? null
                    : widget._trailingBuilder(context),
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
                      localizer().addedPeople.toUpperCase(),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  Expanded(
                    child: ListOfPeopleWidget(
                      trailingWidget: Icon(Icons.clear),
                      users: viewModel.selectedUsers,
                      trailingSelector: (x) {
                        viewModel.deselect(x);
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
