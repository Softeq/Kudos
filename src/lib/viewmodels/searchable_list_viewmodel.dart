import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:sorted_list/sorted_list.dart';

abstract class SearchableListViewModel<T> extends BaseViewModel {
  @protected
  final List<T> dataList;

  String _query = "";
  StreamController<String> _streamController;
  Stream<Iterable<T>> _dataStream;

  Stream<Iterable<T>> get dataStream => _dataStream;
  bool get isDataListEmpty => dataList.isEmpty;
  String get query => _query;

  set query(String value) {
    if (_query == value) return;

    _query = value;
    filterByName(query);
    notifyListeners();
  }

  SearchableListViewModel({int Function(T, T) sortFunc})
      : dataList = sortFunc == null ? new List<T>() : new SortedList(sortFunc) {
    _initFilter();
  }

  void _initFilter() {
    _streamController = StreamController<String>();

    _dataStream = _streamController.stream
        .debounceTime(Duration(milliseconds: 100))
        .distinct()
        .transform(
      StreamTransformer<String, List<T>>.fromHandlers(
        handleData: (query, sink) {
          if (dataList == null || dataList.isEmpty) {
            return;
          }

          sink.add(_filterByName(query));
        },
      ),
    );
  }

  Iterable<T> _filterByName(String query) {
    return query.isEmpty
        ? dataList
        : dataList.where((x) => filter(x, query)).toList();
  }

  void clearFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  bool filter(T item, String query);

  void filterByName(String query) => _streamController.add(query);

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
