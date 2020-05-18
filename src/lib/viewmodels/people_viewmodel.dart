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

  PublishSubject<String> _filterByNameSubject;

  PeopleViewModel({this.excludeCurrentUser}) {
    _filterByNameSubject = PublishSubject<String>();
  }

  @override
  void dispose() {
    _filterByNameSubject.close();
    super.dispose();
  }

  Stream<List<User>> get people => _filterByNameSubject.stream
      .debounceTime(Duration(milliseconds: 300))
      .distinct()
      .transform(StreamTransformer<String, List<User>>.fromHandlers(
        handleData: _filter,
      ));

  Future<void> initialize() async {
    await _loadPeopleList();
    filterByName("");
  }

  void filterByName(String query) {
    _filterByNameSubject.sink.add(query);
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

  void _filter(query, sink) async {
    if (query.isEmpty) {
      sink.add(_people);
    } else {
      sink.add(_filterByName(_people, query));
    }
  }

  List<User> _filterByName(List<User> people, String query) {
    final filteredPeople = people.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return filteredPeople;
  }
}
