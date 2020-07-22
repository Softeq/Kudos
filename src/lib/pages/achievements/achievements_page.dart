import 'package:flutter/material.dart';
import 'package:kudosapp/extensions/list_extensions.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/achievement_owner_model.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/models/selection_action.dart';
import 'package:kudosapp/pages/achievements/edit_achievement_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/viewmodels/achievements/achievements_viewmodel.dart';
import 'package:kudosapp/widgets/achievements/achievement_list_item_widget.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class AchievementsPageRoute extends MaterialPageRoute<AchievementModel> {
  AchievementsPageRoute({
    @required SelectionAction selectionAction,
    @required bool showAddButton,
    bool Function(AchievementModel) achievementsFilter,
    Icon selectorIcon,
  }) : super(
          builder: (context) => AchievementsPage(
            selectionAction: selectionAction,
            showAddButton: showAddButton,
            achievementsFilter: achievementsFilter,
            selectorIcon: selectorIcon,
          ),
          fullscreenDialog: true,
        );
}

class AchievementsPage extends StatelessWidget {
  final bool Function(AchievementModel) _achievementsFilter;
  final SelectionAction _selectionAction;
  final Icon _selectorIcon;
  final bool _showAddButton;

  AchievementsPage({
    @required SelectionAction selectionAction,
    @required bool showAddButton,
    bool Function(AchievementModel) achievementsFilter,
    Icon selectorIcon,
  })  : _achievementsFilter = achievementsFilter,
        _selectorIcon = selectorIcon,
        _selectionAction = selectionAction,
        _showAddButton = showAddButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: localizer().achievements,
        elevation: 0,
      ),
      body: ChangeNotifierProvider<AchievementsViewModel>(
        create: (context) =>
            AchievementsViewModel(achievementsFilter: _achievementsFilter),
        child: TopDecorator.buildLayoutWithDecorator(
          Consumer<AchievementsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isBusy) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: ChangeNotifierProvider<
                          ListNotifier<AchievementModel>>.value(
                        value: viewModel.achievements,
                        child: Consumer<ListNotifier<AchievementModel>>(
                          builder: (context, notifier, child) {
                            if (notifier.isEmpty) {
                              return Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.7,
                                  child: Text(
                                    localizer().createYourOwnAchievements,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }

                            return _AchievementListWidget.from(
                              notifier.items,
                              (achievement) => _onItemClicked(
                                  context, viewModel, achievement),
                              _selectorIcon,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      end: 16.0,
                      bottom: 32.0,
                      child: Visibility(
                        visible: _showAddButton,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              EditAchievementRoute.createUserAchievement(
                                viewModel.currentUser,
                              ),
                            );
                          },
                          child: KudosTheme.addIcon,
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _onItemClicked(BuildContext context, AchievementsViewModel viewModel,
      AchievementModel achievement) {
    switch (_selectionAction) {
      case SelectionAction.OpenDetails:
        viewModel.onAchievementClicked(context, achievement);
        break;
      case SelectionAction.Pop:
        Navigator.of(context).pop(achievement);
        break;
    }
  }
}

class _AchievementListWidget extends StatelessWidget {
  final List<Widget> _items;

  factory _AchievementListWidget.from(
    List<AchievementModel> input,
    void Function(AchievementModel) onAchievementClicked,
    Icon selectorIcon,
  ) {
    final sortedList = input.toList();
    sortedList.sortThen(
      (x, y) {
        if (x.owner.type != AchievementOwnerType.team &&
            y.owner.type == AchievementOwnerType.team) {
          return -1;
        } else if (x.owner.type == AchievementOwnerType.team &&
            y.owner.type != AchievementOwnerType.team) {
          return 1;
        } else {
          return 0;
        }
      },
      (x, y) {
        if (x.owner.type != AchievementOwnerType.team &&
            y.owner.type != AchievementOwnerType.team) {
          return 0;
        }

        return x.owner.name.compareTo(y.owner.name);
      },
    );

    final myAchievementsText = localizer().myAchievements;
    final listItems = List<Widget>();
    String groupName;

    for (var i = 0; i < sortedList.length; i++) {
      final item = sortedList[i];
      final itemGroup = item.owner.type != AchievementOwnerType.team
          ? myAchievementsText
          : item.owner.name;
      if (groupName != itemGroup) {
        groupName = itemGroup;
        listItems.add(_GroupListItem(itemGroup));
      }
      listItems.add(
          AchievementListItemWidget(item, onAchievementClicked, selectorIcon));
    }

    return _AchievementListWidget._(listItems);
  }

  _AchievementListWidget._(this._items);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _items[index];
      },
      itemCount: _items.length,
      padding: EdgeInsets.only(
        top: TopDecorator.height,
        bottom: BottomDecorator.height,
      ),
    );
  }
}

class _GroupListItem extends StatelessWidget {
  final String name;

  _GroupListItem(this.name);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        bottom: 16.0,
      ),
      child: Text(
        name,
        style: KudosTheme.listGroupTitleTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
