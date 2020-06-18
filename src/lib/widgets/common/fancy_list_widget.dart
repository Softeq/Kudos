import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:kudosapp/models/list_notifier.dart';
import 'package:provider/provider.dart';

class FancyListWidget<T> extends StatelessWidget {
  final _random = Random();
  final ListNotifier<T> _items;
  final String Function(T) _getItemTitle;
  final String _emptyPlaceholder;

  final Map<T, Color> colors = new Map<T, Color>();

  FancyListWidget(this._items, this._getItemTitle, this._emptyPlaceholder);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListNotifier<T>>.value(
      value: _items,
      child: Consumer<ListNotifier<T>>(builder: (context, teamMembers, child) {
        if (teamMembers.items.isEmpty) {
          return Text(_emptyPlaceholder);
        } else {
          var memberWidgets =
              teamMembers.items.map((x) => _buildMember(x)).toList();
          return Wrap(
            spacing: 8.0,
            children: memberWidgets,
          );
        }
      }),
    );
  }

  Widget _buildMember(T itemViewModel) {
    if (!colors.containsKey(itemViewModel)) {
      colors[itemViewModel] = _getRandomColor();
    }

    var color = colors[itemViewModel];
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 6.0,
      ),
      margin: EdgeInsets.only(bottom: 4.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(
          40,
          color.red,
          color.green,
          color.blue,
        ),
        border: Border(
          bottom: BorderSide(
            color: color,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Text(
        _getItemTitle(itemViewModel),
      ),
    );
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(255),
      _random.nextInt(255),
      _random.nextInt(255),
    );
  }
}
