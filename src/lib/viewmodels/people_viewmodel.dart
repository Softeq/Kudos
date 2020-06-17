import 'dart:async';

import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class PeopleViewModel extends BaseViewModel {
  final PeopleService _peopleService = locator<PeopleService>();
  final List<User> _people = [];
  final Set<String> _excludedUserIds;

  final PublishSubject<String> _filterByNameSubject;

  PeopleViewModel({Set<String> excludedUserIds})
      : _filterByNameSubject = PublishSubject<String>(),
        _excludedUserIds = excludedUserIds;

  @override
  void dispose() {
    _filterByNameSubject.close();
    super.dispose();
  }

  Stream<List<User>> get people => _filterByNameSubject.stream
      .debounceTime(Duration(milliseconds: 100))
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

      people = await _peopleService.getAllUsers();

      _people.addAll(people);

      if (_excludedUserIds != null) {
        _people.removeWhere((user) => _excludedUserIds.contains(user.id));
      }
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
