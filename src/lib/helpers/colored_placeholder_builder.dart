import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColoredPlaceholder {
  final Color color;
  final String abbreviation;

  ColoredPlaceholder(this.abbreviation, this.color);
}

class ColoredPlaceholderBuilder {
  static final colors = [
    Color(0xff1abc9c),
    Color(0xff2ecc71),
    Color(0xff9b59b6),
    Color(0xff16a085),
    Color(0xff44ECC5),
    Color(0xff27ae60),
    Color(0xff2980b9),
    Color(0xffA43AF5),
    Color(0xfff1c40f),
    Color(0xff3AC9F5),
    Color(0xffAE74F0),
    Color(0xff53E9E9),
    Color(0xfff39c12),
    Color(0xff3498db),
    Color(0xff9523D7),
    Color(0xff840C6C),
  ];

  static ColoredPlaceholder build(String name) {
    var abbr = _getAbbreviation(name);
    var index = abbr.hashCode.abs() % (colors.length - 1);

    if (abbr.isEmpty) {
      return ColoredPlaceholder(abbr, Colors.white);
    }

    return ColoredPlaceholder(abbr, colors[index]);
  }

  static String _getAbbreviation(String data) {
    if (data == null || data.isEmpty) {
      return "";
    } else {
      return data
          .trim()
          .split(new RegExp('\\s+'))
          .take(2)
          .map((e) => e[0].toUpperCase())
          .join();
    }
  }
}
