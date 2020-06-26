import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/user_picker_viewmodel.dart';
import 'package:kudosapp/widgets/list_of_people_widget.dart';

class UserPickerRoute extends MaterialPageRoute<List<User>> {
  UserPickerRoute({
    @required bool allowMultipleSelection,
    @required bool allowCurrentUser,
    String searchHint,
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
              child: _UserPickerPage(allowMultipleSelection, trailingBuilder,
                  searchHint ?? localizer().search),
            );
          },
          fullscreenDialog: true,
        );
}

class _UserPickerPage extends StatefulWidget {
  final bool _allowMultipleSelection;
  final String _searchHint;
  final WidgetBuilder _trailingBuilder;

  _UserPickerPage(
      this._allowMultipleSelection, this._trailingBuilder, this._searchHint);

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
      appBar: GradientAppBar.withWidget(
        TextField(
          style: KudosTheme.searchTextStyle,
          cursorColor: KudosTheme.accentColor,
          controller: _textEditingController,
          decoration: InputDecoration.collapsed(
            hintText: widget._searchHint,
            hintStyle: KudosTheme.searchHintStyle,
          ),
          onChanged: (x) {
            var viewModel = Provider.of<UserPickerViewModel>(
              context,
              listen: false,
            );
            viewModel.requestSearch(x);
          },
        ),
        actions: actions,
      ),
      body: Consumer<UserPickerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.users.isEmpty) {
            return Container();
          }
          return ListOfPeopleWidget(
            itemSelector: (x) {
              if (widget._allowMultipleSelection) {
                viewModel.toggleUserSelection(x);
              } else {
                Navigator.of(context).pop([x]);
              }
            },
            users: viewModel.users,
            trailingWidgetFunction: (x) => widget._trailingBuilder != null
                ? widget._trailingBuilder(context)
                : viewModel.isUserSelected(x)
                    ? Icon(Icons.clear,
                        color: KudosTheme.destructiveButtonColor)
                    : Icon(Icons.add, color: KudosTheme.accentColor),
          );
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
