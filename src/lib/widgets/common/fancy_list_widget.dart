import 'package:flutter/widgets.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/helpers/list_notifier.dart';
import 'package:kudosapp/widgets/common/fancy_item_widget.dart';
import 'package:provider/provider.dart';

class FancyListWidget<T> extends StatelessWidget {
  final ListNotifier<T> _items;
  final String Function(T) _getItemTitle;
  final void Function(T) _onItemClicked;
  final String _emptyPlaceholder;

  FancyListWidget(this._items, this._getItemTitle, this._emptyPlaceholder,
      [this._onItemClicked]);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ListNotifier<T>>.value(
      value: _items,
      child: Consumer<ListNotifier<T>>(builder: (context, teamMembers, child) {
        if (teamMembers.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              _emptyPlaceholder,
              style: KudosTheme.sectionEmptyTextStyle,
            ),
          );
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

  Widget _buildMember(T item) {
    return FancyItemWidget(
        _getItemTitle(item), () => _onItemClicked?.call(item));
  }
}
