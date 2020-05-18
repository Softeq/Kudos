import 'dart:async';

import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class PeopleViewModel extends BaseViewModel {
  final PeopleService _peopleService = locator<PeopleService>();
  final List<User> _people = [];
  final bool excludeCurrentUser;

  PublishSubject<String> _searchQuery;

  PeopleViewModel({this.excludeCurrentUser}) {
    _searchQuery = PublishSubject<String>();
  }

  @override
  void dispose() {
    _searchQuery.close();
    super.dispose();
  }

  Stream<List<User>> get peopleList => _searchQuery.stream
      .debounceTime(Duration(milliseconds: 300))
      .distinct()
      .transform(StreamTransformer<String, List<User>>.fromHandlers(
        handleData: _search,
      ));

  Future<void> initialize() async {
    await _loadPeopleList();
    filterByName("");
  }

  void filterByName(String query) {
    _searchQuery.sink.add(query);
  }

  Future<void> _loadPeopleList() async {
    if (_people.isEmpty) {
      List<User> people = [];
      if (excludeCurrentUser == null) {
        people = await _peopleService.getAllUsers();
      } else {
        people = await _peopleService.getAllowedUsers();
      }
      _people.addAll(people);
    }
  }

  void _search(query, sink) async {
    if (query.isEmpty) {
      sink.add(_people);
    }

    final results =
        _people.where((user) => _filterByName(user, query)).toList();
    sink.add(results);
  }

  bool _filterByName(User user, String query) {
    return user.name.toLowerCase().contains(query.toLowerCase());
  }
}
