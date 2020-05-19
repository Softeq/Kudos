import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/user_picker_page.dart';
import 'package:kudosapp/service_locator.dart';
import 'package:kudosapp/services/localization_service.dart';
import 'package:kudosapp/viewmodels/achievement_details_viewmodel.dart';
import 'package:kudosapp/widgets/achievement_horizontal_widget.dart';
import 'package:provider/provider.dart';

class AchievementDetailsRoute extends MaterialPageRoute {
  AchievementDetailsRoute(Achievement achievement)
      : super(
          builder: (context) {
            return ChangeNotifierProvider<AchievementDetailsViewModel>(
              create: (context) {
                return AchievementDetailsViewModel()..initialize(achievement);
              },
              child: _AchievementDetailsPage(),
            );
          },
        );
}

class _AchievementDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AchievementDetailsPageState();
}

class _AchievementDetailsPageState extends State<_AchievementDetailsPage> {
  final TextEditingController _inputController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementDetailsViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(viewModel.achievementViewModel.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  EditAchievementRoute(
                    achievement: viewModel.achievementViewModel.achievement,
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: viewModel.isBusy
              ? Center(child: CircularProgressIndicator())
              : _buildBody(viewModel),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.send),
          onPressed: _sendTapped,
        ),
      );
    });
  }

  Widget _buildBody(
    AchievementDetailsViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        Container(
          height: 140,
          child: AchievementHorizontalWidget(viewModel.achievementViewModel),
        ),
        SizedBox(height: 24),
        _PopularityWidget(viewModel.statisticsValue),
        SizedBox(height: 24),
        _AchievementHoldersWidget(viewModel.achievementHolders),
        SizedBox(height: 24),
        _AchievementOwnerWidget(viewModel.ownerName)
      ],
    );
  }

  Future<void> _sendTapped() async {
    var user = await Navigator.of(context).push(
      UserPickerRoute(
        allowMultipleSelection: false,
        allowCurrentUser: false,
        trailingBuilder: (context) {
          return Icon(Icons.send);
        },
      ),
    );
    if (user != null && user.isNotEmpty) {
      await _sendAchievementToUser(user.first);
    }
  }

  Future<void> _sendAchievementToUser(User user) async {
    try {
      var commentText = await _putCommentDialog();
      if (commentText != null) {
        var viewModel =
            Provider.of<AchievementDetailsViewModel>(context, listen: false);
        await viewModel.sendTo(user, commentText);

        _notifyAboutSuccess();
      }
    } catch (error) {
      _notifyAboutError(error);
    }
  }

  Future<String> _putCommentDialog() async {
    bool accepted = false;

    await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: _inputController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: locator<LocalizationService>().writeAComment,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(locator<LocalizationService>().cancel),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(locator<LocalizationService>().send),
                onPressed: () {
                  accepted = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    return accepted ? _inputController.text : null;
  }

  void _notifyAboutSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "👍",
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          Text(
            locator<LocalizationService>().sentSuccessfully,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 4),
    ));
  }

  void _notifyAboutError(error) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        locator<LocalizationService>().generalErrorMessage,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      backgroundColor: Theme.of(context).errorColor,
      duration: Duration(seconds: 4),
    ));
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

class _PopularityWidget extends StatelessWidget {
  final double _popularityPercent;

  _PopularityWidget(this._popularityPercent);

  @override
  Widget build(BuildContext context) {
    var localizationService = locator<LocalizationService>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _SectionTitleWidget(localizationService.achivementStatisticsTitle,
            localizationService.achivementStatisticsTooltip),
        SizedBox(height: 12),
        Padding(
            padding: EdgeInsets.only(left: 12),
            child: Align(
                alignment: Alignment.topLeft,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 16,
                    width: 144,
                    child: LinearProgressIndicator(
                      value: _popularityPercent, // percent filled
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                      backgroundColor: Theme.of(context).primaryColorLight,
                    ),
                  ),
                )))
      ],
    );
  }
}

class _SectionTitleWidget extends StatelessWidget {
  final String _title;
  final String _tooltipTitle;

  _SectionTitleWidget(this._title, [this._tooltipTitle]);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _title,
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(width: 8),
          Visibility(
              visible: _tooltipTitle?.isNotEmpty ?? false,
              child: Tooltip(
                message: _tooltipTitle ?? "not visible",
                child: Icon(
                  Icons.info,
                  size: 20,
                  color: Colors.grey,
                ),
              ))
        ]);
  }
}

class _AchievementOwnerWidget extends StatelessWidget {
  final String _ownerName;

  _AchievementOwnerWidget(this._ownerName);

  @override
  Widget build(BuildContext context) {
    var localizationService = locator<LocalizationService>();
    return Column(children: <Widget>[
      _SectionTitleWidget(localizationService.achivementOwnerTitle),
      SizedBox(height: 12),
      Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                _ownerName,
                style: Theme.of(context).textTheme.headline6,
              )))
    ]);
  }
}

class _AchievementHoldersWidget extends StatelessWidget {
  final List<AchievementHolder> _achievementHolders;

  _AchievementHoldersWidget(this._achievementHolders);

  @override
  Widget build(BuildContext context) {
    var localizationService = locator<LocalizationService>();
    Widget content;

    if (_achievementHolders == null || _achievementHolders.length == 0) {
      content = Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                localizationService.achivementHoldersEmptyPlaceholder,
                style: Theme.of(context).textTheme.headline6,
              )));
    } else {
      content = Padding(
          padding: EdgeInsets.only(left: 12),
          child: GridView.count(
              children: _buildListItems(context, _achievementHolders),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 7,
              physics: ClampingScrollPhysics()));
    }
    return Column(children: <Widget>[
      _SectionTitleWidget(localizationService.achivementHoldersTitle),
      SizedBox(height: 12),
      content
    ]);
  }

  List<Widget> _buildListItems(
      BuildContext context, List<AchievementHolder> achievementHolders) {
    return achievementHolders == null
        ? new List<Widget>()
        : achievementHolders
            .map((u) => Tooltip(
                message: u.recipient.name,
                child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(u.recipient.imageUrl))))
            .toList();
  }
}
