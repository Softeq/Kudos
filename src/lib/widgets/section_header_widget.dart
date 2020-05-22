import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            ]));
  }
}
