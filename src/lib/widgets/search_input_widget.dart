import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/search_input_viewmodel.dart';

class SearchInputWidget extends StatelessWidget {
  static const double _leftPadding = 0;
  static const double _rightPadding = 24;
  static const double _topBottomPadding = 4;

  final String hintText;
  final double iconSize;

  SearchInputWidget({this.hintText, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchInputViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsets.fromLTRB(_leftPadding, _topBottomPadding, _rightPadding, _topBottomPadding),
      child: Row(
        children: <Widget>[
          Container(
            width: iconSize ?? 92,
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
              onChanged: (value) => viewModel.query = value,
              decoration: InputDecoration(
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: hintText,
                  hintStyle: KudosTheme.searchHintStyle),
            ),
          ),
        ],
      ),
    );
  }
}
