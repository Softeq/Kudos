import 'dart:async';

import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/database/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class PeopleViewModel extends BaseViewModel {
  final PeopleService _peopleService = locator<PeopleService>();
  final List<User> _peopleList = [];
  final Set<String> _excludedUserIds;

  StreamController<String> _streamController;
  Stream<List<User>> _peopleStream;

  Stream<List<User>> get peopleStream => _peopleStream;

  PeopleViewModel({Set<String> excludedUserIds})
      : _excludedUserIds = excludedUserIds {
    _initFilter();
  }

  Future<void> initialize() async {
    await _loadPeopleList();
    filterByName("");
  }

  void filterByName(String query) => _streamController.add(query);

    void _initFilter() {
    _streamController = StreamController<String>();

    _peopleStream = _streamController.stream
        .debounceTime(Duration(milliseconds: 100))
        .distinct()
        .transform(StreamTransformer<String, List<User>>.fromHandlers(
          handleData: (query, sink) => sink.add(query.isEmpty ? _peopleList : _filterByName(_peopleList, query)),
        ));
  }

  Future<void> _loadPeopleList() async {
    if (_peopleList.isEmpty) {
      List<User> people = [];

      people = await _peopleService.getAllUsers();

      _peopleList.addAll(people);

      if (_excludedUserIds != null) {
        _peopleList.removeWhere((user) => _excludedUserIds.contains(user.id));
      }
    }
  }

  List<User> _filterByName(List<User> people, String query) {
    final filteredPeople = people
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredPeople;
  }
}
