import 'package:flutter/material.dart';

class KudosTheme {
  static final Color textColor = Colors.white;
  static final Color accentColor = Color.fromARGB(255, 3, 218, 197);
  static final Color splashColor = Color.fromARGB(140, 3, 218, 197);
  static final Color highlightColor = Color.fromARGB(50, 3, 218, 197);
  static final Color buttonSplashColor = Color.fromARGB(255, 3, 255, 255);
  static final Color tabBarSplashColor = Color.fromARGB(140, 157, 138, 255);
  static final Color tabBarHighlightColor = Color.fromARGB(50, 157, 138, 255);
  static final Color contentColor = Colors.white;
  static final Color mainGradientStartColor = Color.fromARGB(255, 106, 24, 163);
  static final Color mainGradientEndColor = Color.fromARGB(255, 57, 38, 179);
  static final Color destructiveButtonColor = Color.fromARGB(255, 255, 59, 48);

  static final LinearGradient mainGradient = LinearGradient(
    colors: <Color>[
      KudosTheme.mainGradientStartColor,
      KudosTheme.mainGradientEndColor,
    ],
  );

  static final BoxDecoration tooltipDecoration = BoxDecoration(
    color: KudosTheme.accentColor.withAlpha(160),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withAlpha(50),
          blurRadius: 4.0,
          offset: Offset(0, 2))
    ],
  );

  static final TextStyle tooltipTextStyle = TextStyle(
    fontSize: 14.0,
    color: mainGradientEndColor,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle appBarTitleTextStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle searchTextStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle searchHintStyle = TextStyle(
    fontSize: 16.0,
    color: Color.fromARGB(160, 255, 255, 255),
    fontWeight: FontWeight.w500,
  );

  static final TextStyle userNameTitleTextStyle = TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle userNameSubTitleTextStyle = TextStyle(
    fontSize: 14.0,
    color: Color.fromARGB(160, 255, 255, 255),
    fontWeight: FontWeight.w500,
  );

  static final TextStyle sectionTitleTextStyle = TextStyle(
    fontSize: 16.0,
    color: mainGradientEndColor,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle sectionEmptyTextStyle = TextStyle(
    fontSize: 15.0,
    color: Color.fromARGB(160, 0, 0, 0),
    fontWeight: FontWeight.w500,
  );

  static final TextStyle descriptionTextStyle = TextStyle(
    fontSize: 17.0,
    color: Color.fromARGB(160, 0, 0, 0),
    fontWeight: FontWeight.w500,
  );

  static final TextStyle errorTextStyle = TextStyle(
    fontSize: 15.0,
    color: Colors.redAccent,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle listTitleTextStyle = TextStyle(
    fontSize: 16.0,
    color: mainGradientEndColor,
    fontWeight: FontWeight.w800,
  );

  static final TextStyle listGroupTitleTextStyle = TextStyle(
    fontSize: 19.0,
    color: mainGradientEndColor,
    shadows: [
      Shadow(
        color: accentColor.withAlpha(100),
        blurRadius: 4,
        offset: Offset(0, 2),
      )
    ],
    fontWeight: FontWeight.w600,
  );

  static final TextStyle listSubTitleTextStyle = TextStyle(
    fontSize: 14.0,
    color: Color.fromRGBO(12, 12, 12, 1),
  );

  static final TextStyle listContentTextStyle = TextStyle(
    fontSize: 16.0,
    color: Color.fromRGBO(12, 12, 12, 1),
    fontWeight: FontWeight.w500,
  );

  static final TextStyle listEmptyContentTextStyle = TextStyle(
    fontSize: 16.0,
    color: Color.fromARGB(100, 0, 0, 0),
  );

  static final TextStyle screenStateTitleTextStyle = TextStyle(
    fontSize: 20.0,
    color: Color.fromARGB(160, 0, 0, 0),
    fontWeight: FontWeight.w500,
  );

  static final TextStyle raisedButtonTextStyle = TextStyle(
    fontSize: 16.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle fancyListItemTextStyle = TextStyle(
    fontSize: 14.0,
    color: Color.fromARGB(180, 0, 0, 0),
    fontWeight: FontWeight.w500,
  );
}
