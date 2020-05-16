import 'package:flutter/foundation.dart';

class ListNotifier<T> extends ChangeNotifier {
  final List<T> items = List<T>();

  void replace(Iterable<T> newItems) {
    items.clear();
    items.addAll(newItems);
    notifyListeners();
  }
}
