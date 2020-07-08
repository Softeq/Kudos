import 'dart:async';

import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/people_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class PeopleViewModel extends BaseViewModel {
  final PeopleService _peopleService = locator<PeopleService>();
  final List<UserModel> _peopleList = [];
  final Set<String> _excludedUserIds;

  StreamController<String> _streamController;
  Stream<List<UserModel>> _peopleStream;

  Stream<List<UserModel>> get peopleStream => _peopleStream;

  PeopleViewModel({Set<String> excludedUserIds})
      : _excludedUserIds = excludedUserIds {
    _initFilter();
    _initialize();
  }

  void _initialize() async {
    await _loadPeopleList();
    filterByName("");
  }

  void filterByName(String query) => _streamController.add(query);

  void _initFilter() {
    _streamController = StreamController<String>();

    _peopleStream = _streamController.stream
        .debounceTime(Duration(milliseconds: 100))
        .distinct()
        .transform(StreamTransformer<String, List<UserModel>>.fromHandlers(
          handleData: (query, sink) => sink.add(
              query.isEmpty ? _peopleList : _filterByName(_peopleList, query)),
        ));
  }

  Future<void> _loadPeopleList() async {
    if (_peopleList.isEmpty) {
      List<UserModel> people = [];

      people = await _peopleService.getAllUsers();

      _peopleList.addAll(people);

      if (_excludedUserIds != null) {
        _peopleList.removeWhere((x) => _excludedUserIds.contains(x.id));
      }
    }
  }

  List<UserModel> _filterByName(List<UserModel> people, String query) {
    final filteredPeople = people
        .where((x) => x.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredPeople;
  }
}
