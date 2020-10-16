import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/viewmodels/searchable_list_viewmodel.dart';

class SearchInputWidget<T extends SearchableListViewModel>
    extends StatelessWidget {
  static const double _leftPadding = 0;
  static const double _rightPadding = 24;
  static const double _topBottomPadding = 4;

  final T _viewModel;
  final String _hintText;
  final double _iconSize;

  SearchInputWidget(
    this._viewModel, {
    String hintText,
    double iconSize,
  })  : _hintText = hintText,
        _iconSize = iconSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        _leftPadding,
        _topBottomPadding,
        _rightPadding,
        _topBottomPadding,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: _iconSize ?? 92,
            child: Center(
              child: Icon(
                Icons.search,
                color: KudosTheme.accentColor,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              style: KudosTheme.searchTextStyle,
              cursorColor: KudosTheme.accentColor,
              onChanged: (value) => _viewModel.query = value,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: _hintText,
                hintStyle: KudosTheme.searchHintStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
