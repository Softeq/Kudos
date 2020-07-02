import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/widgets/common/scroll_behaviors.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';
import 'package:sprintf/sprintf.dart';

class ListOfPeopleWidget extends StatelessWidget {
  final List<User> users;
  final void Function(User user) itemSelector;
  final void Function(User user) trailingSelector;
  final Widget trailingWidget;
  final Widget Function(User user) trailingWidgetFunction;
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
    return ScrollConfiguration(
      behavior: DisableGlowingOverscrollBehavior(),
      child: ListView.builder(
        padding: padding,
        itemCount: users.length,
        itemBuilder: (context, index) => _buildItem(context, index),
      ),
    );
  }

  String getReceivedAchievementsString(int count) {
    if (count == null || count == 0) {
      return localizer().receivedNoAchievements;
    } else {
      return sprintf(localizer().receivedAchievements, [count]);
    }
  }

  Widget _buildItem(context, index) {
    final user = users[index];

    return SimpleListItem(
      title: user.name,
      description: getReceivedAchievementsString(
          user.receivedAchievementsCount),
      onTap: () => itemSelector?.call(user),
      imageUrl: user.imageUrl,
      selectorIcon: trailingWidget ?? trailingWidgetFunction(user),
      imageShape: ImageShape.circle(50),
      useTextPlaceholder: true,
      addHeroAnimation: true,
    );
  }
}
