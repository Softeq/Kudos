import 'package:flutter/material.dart';
import 'package:kudosapp/widgets/group_list_item_widget.dart';
import 'package:kudosapp/models/groupped_list_item.dart';
import 'package:kudosapp/widgets/decorations/bottom_decorator.dart';
import 'package:kudosapp/widgets/decorations/top_decorator.dart';

class GrouppedListWidget<T> extends StatelessWidget {
  final _items = new List<Widget>();
  final Widget Function(T) _itemBuilder;

  GrouppedListWidget(
    Iterable<GrouppedListItem<T>> items,
    this._itemBuilder,
  ) {
    String groupName;

    for (var groupItem in items) {
      final itemGroup = groupItem.groupName;
      if (groupName != itemGroup) {
        groupName = itemGroup;
        _items.add(GroupListItemWidget(itemGroup));
      }
      _items.add(_itemBuilder(groupItem.item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView.builder(
        itemBuilder: (context, index) => _items[index],
        itemCount: _items.length,
        padding: EdgeInsets.only(
          top: TopDecorator.height,
          bottom: BottomDecorator.height,
        ),
      ),
    );
  }
}
