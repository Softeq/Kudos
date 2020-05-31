import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kudosapp/models/messages/team_updated_message.dart';
import 'package:kudosapp/models/team.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/teams_service.dart';
import 'package:kudosapp/viewmodels/base_viewmodel.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class EditTeamViewModel extends BaseViewModel {
  final _teamsService = locator<TeamsService>();
  final _eventBus = locator<EventBus>();
  final Team _initialTeam;
  final ImageViewModel _imageViewModel;

  factory EditTeamViewModel.fromTeam(Team team) {
    return EditTeamViewModel._(team);
  }

  EditTeamViewModel._(this._initialTeam)
      : _imageViewModel = ImageViewModel()
          ..initialize(_initialTeam?.imageUrl, null, false);

  String get pageTitle =>
      _initialTeam == null ? localizer().createTeam : localizer().editTeam;

  ImageViewModel get imageViewModel => _imageViewModel;

  String get initialImageUrl => _initialTeam?.imageUrl;

  String get initialName => _initialTeam?.name ?? "";

  String get initialDescription => _initialTeam?.description ?? "";

  void pickFile() async {
    if (_imageViewModel.isBusy) {
      return;
    }

    _imageViewModel.update(isBusy: true);

    final file = await FilePicker.getFile(type: FileType.image);

    _imageViewModel.update(isBusy: false, file: file);

    notifyListeners();
  }

  Future<Team> save(String name, String description) async {
    Team team;

    try {
      isBusy = true;

      if (_initialTeam == null) {
        team = await _teamsService.createTeam(
          name,
          description,
          _imageViewModel.file,
        );
      } else {
        team = await _teamsService.editTeam(
          _initialTeam.id,
          name,
          description,
          _imageViewModel.file,
        );
      }
    } finally {
      isBusy = false;
    }

    if (team != null) {
      _eventBus.fire(TeamUpdatedMessage(team));
    }

    return team;
  }
}
