import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/viewmodels/search_input_viewmodel.dart';

class SearchInputWidget extends StatelessWidget {
  final String hintText;

  const SearchInputWidget({Key key, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchInputViewModel>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 70,
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
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: KudosTheme.accentColor)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: KudosTheme.accentColor)),
                hintText: hintText,
                hintStyle: KudosTheme.searchHintStyle
              ),
            ),
          ),
          SizedBox(
            width: 24,
          ),
        ],
      ),
    );
  }
}
