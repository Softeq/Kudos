import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/searchable_list_viewmodel.dart';
import 'package:kudosapp/viewmodels/users/users_viewmodel.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:kudosapp/widgets/list_of_people_widget.dart';
import 'package:kudosapp/widgets/search_input_widget.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class UsersPage extends StatelessWidget {
  final Widget _content = new _UsersContentWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: KudosTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GradientAppBar(title: localizer().people, elevation: 0),
        body: _content,
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _UsersContentWidget();
  }
}

class _UsersContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: <Widget>[
            _buildSearchBar(viewModel),
            Expanded(
              child: TopDecorator.buildLayoutWithDecorator(
                Container(
                  color: KudosTheme.contentColor,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: StreamBuilder(
                          stream: viewModel.dataStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.isEmpty) {
                                return _buildEmpty();
                              }
                              return _buildList(
                                context,
                                viewModel,
                                snapshot.data,
                              );
                            }
                            if (snapshot.hasError) {
                              return _buildError(snapshot.error);
                            }
                            return _buildLoading();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar<T>(SearchableListViewModel<T> viewModel) {
    return SearchInputWidget(
      viewModel,
      hintText: localizer().enterName,
      iconSize: 82,
    );
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(Object error) {
    return Center(
      child: Text(
        sprintf(localizer().detailedError, [error]),
        style: KudosTheme.errorTextStyle,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        localizer().searchEmptyPlaceholder,
        style: KudosTheme.sectionEmptyTextStyle,
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    UsersViewModel viewModel,
    List<UserModel> users,
  ) {
    return ListOfPeopleWidget(
      padding: EdgeInsets.only(
        top: TopDecorator.height,
        bottom: BottomDecorator.height,
      ),
      itemSelector: (user) => viewModel.onItemClicked(context, user),
      users: users,
      trailingWidget: viewModel.selectorIcon,
    );
  }
}
