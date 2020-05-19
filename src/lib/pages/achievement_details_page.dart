import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kudosapp/models/achievement.dart';
import 'package:kudosapp/models/achievement_holder.dart';
import 'package:kudosapp/pages/edit_achievement_page.dart';
import 'package:kudosapp/pages/sending_page.dart';
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
              child: AchievementDetailsPage(),
            );
          },
        );
}

class AchievementDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AchievementDetailsViewModel>(
        builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.achievementViewModel.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(EditAchievementRoute(
                  achievement: viewModel.achievementViewModel.achievement,
                ));
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: viewModel.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildBody(viewModel, context),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          heroTag: null,
          child: Icon(Icons.send),
          onPressed: () => Navigator.of(context).push(
            SendingRoute(viewModel.achievementViewModel.achievement),
          ),
        ),
      );
    });
  }

  Widget _buildBody(
      AchievementDetailsViewModel viewModel, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            height: 140,
            child:
                AchievementHorizontalWidget((viewModel.achievementViewModel))),
        SizedBox(height: 24),
        _PopularityWidget(viewModel.statisticsValue),
        SizedBox(height: 24),
        _AchievementHoldersWidget(viewModel.achievementHolders),
        SizedBox(height: 24),
        _AchievementOwnerWidget(viewModel.ownerName)
      ],
    );
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
