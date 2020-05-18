import 'package:flutter/material.dart';
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
              child: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) => viewModel.query = value,
              decoration: InputDecoration(
                hintText: hintText,
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
