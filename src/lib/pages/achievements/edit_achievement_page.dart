import 'package:flutter/material.dart';
import 'package:kudosapp/helpers/text_editing_value_helper.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/models/team_model.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/dialog_service.dart';
import 'package:kudosapp/viewmodels/achievements/edit_achievement_viewmodel.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:kudosapp/widgets/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class EditAchievementRoute extends MaterialPageRoute {
  EditAchievementRoute.createTeamAchievement(TeamModel team)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditAchievementViewModel>(
                create: (context) =>
                    EditAchievementViewModel.createTeamAchievement(team),
                child: _EditAchievementPage());
          },
          fullscreenDialog: true,
        );

  EditAchievementRoute.createUserAchievement(UserModel user)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditAchievementViewModel>(
                create: (context) =>
                    EditAchievementViewModel.createUserAchievement(user),
                child: _EditAchievementPage());
          },
          fullscreenDialog: true,
        );

  EditAchievementRoute.editAchievement(AchievementModel achievementModel)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<EditAchievementViewModel>(
              create: (context) {
                return EditAchievementViewModel.editAchievement(
                    achievementModel);
              },
              child: _EditAchievementPage(),
            );
          },
          fullscreenDialog: true,
        );
}

class _EditAchievementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<EditAchievementViewModel>(context, listen: false);

    return Scaffold(
      appBar: GradientAppBar(title: viewModel.pageTitle),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () => _onSavePressed(context),
      ),
      body: Consumer<EditAchievementViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isBusy) {
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

  Widget _buildNormalLayout(EditAchievementViewModel viewModel) {
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
              child: _EditableAchievementWidget(
                viewModel,
                onAchievementTitleClicked: _editAchievementTitle,
                onAchievementDescriptionClicked: _editAchievementDescription,
                onAchievementImageClicked: _editAchievementImage,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
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
                  style: KudosTheme.editHintTextStyle,
                ),
                splashColor: KudosTheme.accentColor.withAlpha(80),
                onPressed: () => _editAchievementTitle(viewModel, context),
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
                  style: KudosTheme.editHintTextStyle,
                ),
                splashColor: KudosTheme.accentColor.withAlpha(80),
                onPressed: () =>
                    _editAchievementDescription(viewModel, context),
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
                  style: KudosTheme.editHintTextStyle,
                ),
                splashColor: KudosTheme.accentColor.withAlpha(80),
                onPressed: () => _editAchievementImage(viewModel, context),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editAchievementTitle(
      EditAchievementViewModel viewModel, BuildContext context) async {
    var result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          child: _TextInputWidget(
            title: localizer().name,
            initialValue: viewModel.name,
            height: 180.0,
            maxLines: 1,
          ),
        );
      },
    );
    if (result != null) {
      viewModel.name = result;
    }
  }

  void _editAchievementDescription(
      EditAchievementViewModel viewModel, BuildContext context) async {
    var result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          child: _TextInputWidget(
            title: localizer().description,
            initialValue: viewModel.description,
          ),
        );
      },
    );
    if (result != null) {
      viewModel.description = result;
    }
  }

  void _editAchievementImage(
      EditAchievementViewModel viewModel, BuildContext context) {
    viewModel.pickFile(context);
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
  final double height;
  final int maxLines;

  _TextInputWidget({
    @required this.title,
    @required this.initialValue,
    this.height = 250,
    this.maxLines,
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
    return SizedBox(
      height: widget.height,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 16.0, top: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    style: KudosTheme.listTitleTextStyle,
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      maxLines: widget.maxLines,
                      minLines: null,
                      controller: _textEditingController,
                      style: KudosTheme.descriptionTextStyle,
                      cursorColor: KudosTheme.accentColor,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: KudosTheme.accentColor)),
                      ),
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
                splashColor: KudosTheme.mainGradientStartColor.withAlpha(30),
                child: Text(
                  localizer().cancel,
                  style: TextStyle(
                    color: KudosTheme.mainGradientStartColor,
                  ),
                ),
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
                splashColor: KudosTheme.mainGradientStartColor.withAlpha(30),
                child: Text(
                  localizer().ok,
                  style: TextStyle(
                    color: KudosTheme.mainGradientStartColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EditableAchievementWidget extends StatelessWidget {
  final EditAchievementViewModel viewModel;
  final Function(EditAchievementViewModel, BuildContext)
      onAchievementTitleClicked;
  final Function(EditAchievementViewModel, BuildContext)
      onAchievementDescriptionClicked;
  final Function(EditAchievementViewModel, BuildContext)
      onAchievementImageClicked;

  _EditableAchievementWidget(
    this.viewModel, {
    this.onAchievementTitleClicked,
    this.onAchievementDescriptionClicked,
    this.onAchievementImageClicked,
  });

  @override
  Widget build(BuildContext context) {
    final space = 20.0;
    final halfSpace = space / 2.0;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: halfSpace),
          Expanded(child: Container()),
          Expanded(
            flex: 2,
            child: _buildItem(viewModel),
          ),
          Expanded(child: Container()),
          SizedBox(width: halfSpace),
        ],
      ),
    );
  }

  Widget _buildItem(EditAchievementViewModel viewModel) {
    final borderRadius = 8.0;
    final contentPadding = 8.0;
    return AspectRatio(
      aspectRatio: 0.54,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final radius = constraints.maxWidth / 2.0;
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  bottom: radius,
                ),
                child: Material(
                  elevation: 2,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () =>
                            onAchievementTitleClicked(viewModel, context),
                        child: Padding(
                          padding: EdgeInsets.all(contentPadding),
                          child: Text(
                            viewModel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onAchievementDescriptionClicked(
                              viewModel, context),
                          child: Padding(
                            padding: EdgeInsets.all(contentPadding),
                            child: Text(
                              viewModel.description,
                              maxLines: 5,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  borderRadius: BorderRadius.circular(radius),
                  elevation: 2,
                  child: GestureDetector(
                    onTap: () => onAchievementImageClicked(viewModel, context),
                    child: _EditableRoundedImage(
                      viewModel,
                      radius * 2.0,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EditableRoundedImage extends StatelessWidget {
  final EditAchievementViewModel _viewModel;
  final double _size;

  _EditableRoundedImage(this._viewModel, this._size);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<EditAchievementViewModel>(
        builder: (context, viewModel, child) {
          Widget child;

          if (viewModel.isImageLoading) {
            child = Center(
              child: CircularProgressIndicator(),
            );
          } else {
            child = RoundedImageWidget.circular(
              size: _size,
              imageUrl: viewModel.imageUrl,
              file: viewModel.imageFile,
              placeholderColor: KudosTheme.contentColor,
            );
          }

          return ClipOval(
            child: Container(
              width: _size,
              height: _size,
              color: KudosTheme.contentColor,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
