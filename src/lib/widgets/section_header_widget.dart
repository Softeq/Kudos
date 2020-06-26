import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kudosapp/kudos_theme.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String _title;
  final String _tooltipTitle;

  SectionHeaderWidget(this._title, [this._tooltipTitle]);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _title,
                style: KudosTheme.sectionTitleTextStyle,
              ),
              SizedBox(width: 8),
              Visibility(
                visible: _tooltipTitle?.isNotEmpty ?? false,
                child: SizedBox(
                  child: Tooltip(
                    message: _tooltipTitle ?? "",
                    child: Icon(
                      Icons.info,
                      size: 20,
                      color: KudosTheme.accentColor,
                    ),
                    decoration: KudosTheme.tooltipDecoration,
                    textStyle: KudosTheme.tooltipTextStyle,
                    verticalOffset: 15,
                    margin: EdgeInsets.only(left: 180, right: 20),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  ),
                ),
              ),
            ]));
  }
}
