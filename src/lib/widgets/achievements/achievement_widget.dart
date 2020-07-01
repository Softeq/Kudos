import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';
import 'package:kudosapp/models/achievement_model.dart';
import 'package:kudosapp/viewmodels/image_view_model.dart';
import 'package:kudosapp/widgets/common/rounded_image_widget.dart';
import 'package:provider/provider.dart';

class AchievementWidget extends StatelessWidget {
  final AchievementModel achievement;
  final Function(AchievementModel) onAchievementTitleClicked;
  final Function(AchievementModel) onAchievementDescriptionClicked;
  final Function(AchievementModel) onAchievementImageClicked;

  AchievementWidget(
    this.achievement, {
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
            child: _buildItem(achievement),
          ),
          Expanded(child: Container()),
          SizedBox(width: halfSpace),
        ],
      ),
    );
  }

  Widget _buildItem(AchievementModel achievement) {
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
                        onTap: () {
                          onAchievementTitleClicked(achievement);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(contentPadding),
                          child: Text(
                            achievement.title,
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
                          onTap: () {
                            onAchievementDescriptionClicked(achievement);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(contentPadding),
                            child: Text(
                              achievement.description,
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
                    onTap: () {
                      onAchievementImageClicked(achievement);
                    },
                    child: _EditableRoundedImage(
                      achievement.imageViewModel,
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
  final ImageViewModel _imageViewModel;
  final double _size;

  _EditableRoundedImage(this._imageViewModel, this._size);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _imageViewModel,
      child: Consumer<ImageViewModel>(
        builder: (context, viewModel, child) {
          Widget child;

          if (viewModel.isBusy) {
            child = Center(
              child: CircularProgressIndicator(),
            );
          } else {
            child = RoundedImage.circular(
              size: _size,
              imageUrl: viewModel.imageUrl,
              file: viewModel.file,
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
