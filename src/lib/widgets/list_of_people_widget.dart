import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/dto/user.dart';

class ListOfPeopleWidget extends StatelessWidget {
  final List<User> users;
  final Function(User user) itemSelector;
  final Function(User user) trailingSelector;
  final Widget trailingWidget;

  ListOfPeopleWidget({
    this.users,
    this.itemSelector,
    this.trailingSelector,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => _buildItem(context, index),
    );
  }

  Widget _buildItem(context, index) {
    var user = users[index];
    return _UserWidget(
      onTapped: itemSelector,
      onTrailingTapped: trailingSelector,
      trailing: trailingWidget,
      user: user,
    );
  }
}

class _UserWidget extends StatelessWidget {
  final User user;
  final Function(User user) onTapped;
  final Function(User user) onTrailingTapped;
  final Widget trailing;

  _UserWidget({
    this.user,
    this.onTapped,
    this.onTrailingTapped,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget trailingElement = trailing;
    if (onTrailingTapped != null && trailingElement != null) {
      trailingElement = GestureDetector(
        child: trailingElement,
        onTap: () {
          onTrailingTapped(user);
        },
      );
    }

    Widget item = ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.imageUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: trailingElement,
    );

    if (onTapped != null) {
      item = InkWell(
        child: item,
        onTap: () {
          onTapped(user);
        },
      );
    }

    return item;
  }
}
