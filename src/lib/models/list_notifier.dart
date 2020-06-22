import 'package:flutter/foundation.dart';

class ListNotifier<T> extends ChangeNotifier {
  final List<T> items = List<T>();

  bool get isEmpty => length == 0;
  int get length => items.length;

  void replace(Iterable<T> newItems) {
    items.clear();
    items.addAll(newItems);
    notifyListeners();
  }

  void add(T item) {
    items.add(item);
    notifyListeners();
  }

  void addAll(Iterable<T> newItems) {
    items.addAll(newItems);
    notifyListeners();
  }
}
