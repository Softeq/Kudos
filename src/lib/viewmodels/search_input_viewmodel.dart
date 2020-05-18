import 'package:flutter/foundation.dart';

class SearchInputViewModel extends ChangeNotifier {
  String _query = "";

  String get query => _query;

  set query(String value) {
    if (_query == value) return;

    _query = value;

    notifyListeners();
  }
}