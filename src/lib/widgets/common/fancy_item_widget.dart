import 'package:flutter/widgets.dart';
import 'package:kudosapp/helpers/colored_placeholder_builder.dart';
import 'package:kudosapp/kudos_theme.dart';

class FancyItemWidget extends StatelessWidget {
  final String _title;
  final Function() _onTap;

  FancyItemWidget(this._title, [this._onTap]);

  @override
  Widget build(BuildContext context) {
    var color = ColoredPlaceholderBuilder.build(_title).color;
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 9.0,
        ),
        margin: EdgeInsets.only(bottom: 4.0),
        decoration: BoxDecoration(
          color: color.withAlpha(40),
          border: Border(
            bottom: BorderSide(
              color: color,
              width: 2.0,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: Text(
          _title,
          style: KudosTheme.fancyListItemTextStyle,
        ),
      ),
    );
  }
}
