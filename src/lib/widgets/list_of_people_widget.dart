import 'package:flutter/material.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/base_auth_service.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:sprintf/sprintf.dart';

class ListOfPeopleWidget extends StatelessWidget {
  final List<UserModel> users;
  final void Function(UserModel user) itemSelector;
  final void Function(UserModel user) trailingSelector;
  final Widget trailingWidget;
  final Widget Function(UserModel user) trailingWidgetFunction;
  final EdgeInsets padding;

  ListOfPeopleWidget({
    this.users,
    this.itemSelector,
    this.trailingSelector,
    this.trailingWidget,
    this.trailingWidgetFunction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView.builder(
        padding: padding,
        itemCount: users.length,
        itemBuilder: (context, index) => _buildItem(context, index),
      ),
    );
  }

  String getReceivedAchievementsString(int count) {
    if (count == null || count == 0) {
      return localizer().profileAchievementsEmptyPlaceholder;
    } else {
      return sprintf(localizer().receivedAchievements, [count]);
    }
  }

  String getItemTitle(UserModel user) {
    final authService = locator<BaseAuthService>();

    if (user.id == authService.currentUser.id) {
      return "${user.name} ${localizer().youLabel}";
    } else
      return user.name;
  }

  Widget _buildItem(context, index) {
    final user = users[index];

    return SimpleListItem(
      title: getItemTitle(user),
      description:
          getReceivedAchievementsString(user.receivedAchievementsCount),
      onTap: () => itemSelector?.call(user),
      imageUrl: user.imageUrl,
      selectorIcon: trailingWidget ?? trailingWidgetFunction?.call(user),
      imageShape: ImageShape.circle(50),
      useTextPlaceholder: true,
      addHeroAnimation: true,
    );
  }
}
