import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/widgets/common/scroll_behaviors.dart';
import 'package:kudosapp/widgets/simple_list_item.dart';

class ListOfPeopleWidget extends StatelessWidget {
  final List<User> users;
  final Function(User user) itemSelector;
  final Function(User user) trailingSelector;
  final Widget trailingWidget;
  final Widget Function(User user) trailingWidgetFunction;
  final EdgeInsets padding;

  ListOfPeopleWidget({
    this.users,
    this.itemSelector,
    this.trailingSelector,
    this.trailingWidget,
    this.trailingWidgetFunction,
    this.padding
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

  Widget _buildItem(context, index) {
    var user = users[index];
    return SimpleListItem(
      title: user.name,
      description: user.email,
      onTap: () => itemSelector?.call(user),
      imageUrl: user.imageUrl,
      selectorIcon: trailingWidget ?? trailingWidgetFunction(user),
      imageShape: ImageShape.circle(50),
    );
  }
}
