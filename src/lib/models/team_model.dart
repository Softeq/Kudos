import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';

class TeamModel {
  final Team team;
  final ImageViewModel imageViewModel;

  TeamModel(this.team)
      : imageViewModel = ImageViewModel()
          ..initialize(
            team.imageUrl,
            null,
            false,
          );

  void dispose() {
    imageViewModel.dispose();
  }
}