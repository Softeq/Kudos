import 'package:flutter/material.dart';

@immutable
class GroupedListItem<T> {
  final String groupName;
  final int sortIndex;
  final T item;

  GroupedListItem(this.groupName, this.sortIndex, this.item);
}
