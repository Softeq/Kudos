import 'package:flutter/material.dart';
import 'package:kudosapp/dto/achievement.dart';
import 'package:kudosapp/dto/team.dart';
import 'package:kudosapp/dto/user.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/achievements/edit_achievement_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:kudosapp/helpers/text_editing_value_helper.dart';
import 'package:kudosapp/widgets/achievement_widget.dart';

class EditAchievementRoute extends MaterialPageRoute {
  EditAchievementRoute.createTeamAchievement(Team team)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditAchievementViewModel>(
                create: (context) =>
                    EditAchievementViewModel.createTeamAchievement(team),
                child: _EditAchievementPage(localizer().create));
          },
          fullscreenDialog: true,
        );

  EditAchievementRoute.createUserAchievement(User user)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditAchievementViewModel>(
                create: (context) =>
                    EditAchievementViewModel.createUserAchievement(user),
                child: _EditAchievementPage(localizer().create));
          },
          fullscreenDialog: true,
        );

  EditAchievementRoute.editAchievement(Achievement achievement)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditAchievementViewModel>(
              create: (context) {
                return EditAchievementViewModel.editAchievement(achievement);
              },
              child: _EditAchievementPage(
                localizer().edit,
              ),
            );
          },
          fullscreenDialog: true,
        );
}

class _EditAchievementPage extends StatelessWidget {
  final String _title;

  _EditAchievementPage(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.save),
        onPressed: () => _onSavePressed(context),
      ),
      body: Consumer<EditAchievementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.achievementModel == null) {
            return Container();
          } else if (viewModel.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildNormalLayout(viewModel);
          }
        },
      ),
    );
  }

  static Widget _buildNormalLayout(EditAchievementViewModel viewModel) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var canvasWidth = constraints.maxWidth;
        var canvasHeight = constraints.maxHeight;

        var widgetWidth = (constraints.maxWidth - 60.0) / 2.0;
        var widgetHeight = widgetWidth * 100.0 / 54.0;

        var freeX = canvasWidth - widgetWidth;
        var freeY = canvasHeight - widgetHeight;

        var nameAnchor = Offset(
          canvasWidth * 0.75,
          freeY * 0.25,
        );

        var descriptionAnchor = Offset(
          canvasWidth * 0.25,
          freeY * 0.35,
        );

        var imageAnchor = Offset(
          canvasWidth * 0.25,
          canvasHeight - freeY * 0.25,
        );

        var horizontalOffset = freeX * 0.125;
        var halfHorizontalOffset = horizontalOffset / 2.0;

        var buttonWidth = canvasWidth * 0.5 - horizontalOffset;
        var buttonHeight = freeY * 0.25;

        return Stack(
          children: <Widget>[
            Center(
              child: ChangeNotifierProvider<AchievementModel>.value(
                value: viewModel.achievementModel,
                child: Consumer<AchievementModel>(
                  builder: (context, viewModel, child) {
                    return AchievementWidget([viewModel]);
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _OverlayPainter(
                  canvasHeight: canvasHeight,
                  canvasWidth: canvasWidth,
                  widgetHeight: widgetHeight,
                  widgetWidth: widgetWidth,
                  nameAnchor: nameAnchor,
                  descriptionAnchor: descriptionAnchor,
                  imageAnchor: imageAnchor,
                  horizontalOffset: horizontalOffset,
                  color: Colors.grey[300],
                ),
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromCenter(
                center: Offset(
                  nameAnchor.dx + halfHorizontalOffset,
                  nameAnchor.dy,
                ),
                height: buttonHeight,
                width: buttonWidth,
              ),
              child: FlatButton(
                child: Text(
                  localizer().editName,
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  var result = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: _TextInputWidget(
                          title: localizer().achievementName,
                          initialValue: viewModel.achievementModel.title,
                        ),
                      );
                    },
                  );
                  if (result != null) {
                    viewModel.achievementModel.title = result;
                  }
                },
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromCenter(
                center: Offset(
                  descriptionAnchor.dx - halfHorizontalOffset,
                  descriptionAnchor.dy,
                ),
                height: buttonHeight,
                width: buttonWidth,
              ),
              child: FlatButton(
                child: Text(
                  localizer().editDescription,
                  textAlign: TextAlign.center,
                ),
                onPressed: () async {
                  var result = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: _TextInputWidget(
                          title: localizer().description,
                          initialValue: viewModel.achievementModel.description,
                        ),
                      );
                    },
                  );
                  if (result != null) {
                    viewModel.achievementModel.description = result;
                  }
                },
              ),
            ),
            Positioned.fromRect(
              rect: Rect.fromCenter(
                center: Offset(
                  imageAnchor.dx - halfHorizontalOffset,
                  imageAnchor.dy,
                ),
                height: buttonHeight,
                width: buttonWidth,
              ),
              child: FlatButton(
                child: Text(
                  localizer().editImage,
                  textAlign: TextAlign.center,
                ),
                onPressed: () => viewModel.pickFile(context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onSavePressed(BuildContext context) async {
    var viewModel = Provider.of<EditAchievementViewModel>(
      context,
      listen: false,
    );

    String errorMessage;
    try {
      viewModel.isBusy = true;
      await viewModel.save();
    } on ArgumentError catch (exception) {
      switch (exception.name) {
        case "file":
          errorMessage = localizer().fileIsNullErrorMessage;
          break;
        case "name":
          errorMessage = localizer().nameIsNullErrorMessage;
          break;
        case "description":
          errorMessage = localizer().descriptionIsNullErrorMessage;
          break;
        default:
          errorMessage = localizer().generalErrorMessage;
          break;
      }
    } catch (exception) {
      errorMessage = localizer().generalErrorMessage;
    } finally {
      viewModel.isBusy = false;
    }

    if (errorMessage != null) {
      locator<DialogService>()
          .showOkDialog(context: context, content: errorMessage);
    } else {
      Navigator.of(context).pop();
    }
  }
}

class _OverlayPainter extends CustomPainter {
  final double canvasWidth;
  final double canvasHeight;
  final double widgetWidth;
  final double widgetHeight;
  final Offset nameAnchor;
  final Offset descriptionAnchor;
  final Offset imageAnchor;
  final double horizontalOffset;
  final Color color;

  _OverlayPainter({
    @required this.canvasWidth,
    @required this.canvasHeight,
    @required this.widgetWidth,
    @required this.widgetHeight,
    @required this.nameAnchor,
    @required this.descriptionAnchor,
    @required this.imageAnchor,
    @required this.horizontalOffset,
    @required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint();
    linePaint.color = color;
    linePaint.style = PaintingStyle.stroke;
    linePaint.strokeWidth = 1.0;

    var circlePaint = Paint();
    circlePaint.color = color;
    circlePaint.style = PaintingStyle.fill;

    var radius = 2.0;
    var bottomOffset = 28.0;

    var topLeft = Offset(
      (canvasWidth - widgetWidth) / 2.0,
      (canvasHeight - widgetHeight) / 2.0,
    );

    var namePoint1 = Offset(topLeft.dx + widgetWidth * 0.9, topLeft.dy + 8);
    var namePoint2 = Offset(nameAnchor.dx, nameAnchor.dy + bottomOffset);
    var namePoint3 = Offset(namePoint2.dx + horizontalOffset, namePoint2.dy);

    canvas.drawCircle(
      namePoint1,
      radius,
      circlePaint,
    );

    canvas.drawLine(
      namePoint1,
      namePoint2,
      linePaint,
    );

    canvas.drawLine(
      namePoint2,
      namePoint3,
      linePaint,
    );

    var descriptionPoint1 =
        Offset(topLeft.dx + widgetWidth * 0.1, topLeft.dy + 50);
    var descriptionPoint2 =
        Offset(descriptionAnchor.dx, descriptionAnchor.dy + bottomOffset);
    var descriptionPoint3 =
        Offset(descriptionPoint2.dx - horizontalOffset, descriptionPoint2.dy);

    canvas.drawCircle(
      descriptionPoint1,
      radius,
      circlePaint,
    );

    canvas.drawLine(
      descriptionPoint1,
      descriptionPoint2,
      linePaint,
    );

    canvas.drawLine(
      descriptionPoint2,
      descriptionPoint3,
      linePaint,
    );

    var imagePoint1 = Offset(
        canvasWidth * 0.5, topLeft.dy + widgetHeight - widgetWidth / 4.0);
    var imagePoint2 = Offset(imageAnchor.dx, imageAnchor.dy - bottomOffset);
    var imagePoint3 = Offset(imagePoint2.dx - horizontalOffset, imagePoint2.dy);

    canvas.drawCircle(
      imagePoint1,
      radius,
      circlePaint,
    );

    canvas.drawLine(
      imagePoint1,
      imagePoint2,
      linePaint,
    );

    canvas.drawLine(
      imagePoint2,
      imagePoint3,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _TextInputWidget extends StatefulWidget {
  final String title;
  final String initialValue;

  _TextInputWidget({
    @required this.title,
    @required this.initialValue,
  });

  @override
  State<StatefulWidget> createState() {
    return _TextInputWidgetState();
  }
}

class _TextInputWidgetState extends State<_TextInputWidget> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController.value =
        TextEditingValueHelper.buildForText(widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    maxLines: null,
                    minLines: null,
                    controller: _textEditingController,
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text(localizer().cancel),
            ),
            FlatButton(
              onPressed: () {
                String value;
                if (_textEditingController.text != null &&
                    _textEditingController.text != "") {
                  value = _textEditingController.text;
                }
                Navigator.of(context).pop(value);
              },
              child: Text(localizer().ok),
            ),
          ],
        ),
      ],
    );
  }
}
