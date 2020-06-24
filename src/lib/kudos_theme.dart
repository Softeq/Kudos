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

  static final TextStyle listSubTitleTextStyle = TextStyle(
        fontSize: 14.0,
        color: Color.fromRGBO(189, 189, 189, 1),
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
