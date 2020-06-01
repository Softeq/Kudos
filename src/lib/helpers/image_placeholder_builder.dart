import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImagePlaceholder {
  final Color color;
  final String abbreviation;

  ImagePlaceholder(this.abbreviation, this.color);
}

class ImagePlaceholderBuilder {
  static ImagePlaceholder build(String name) {
    var colors = [
      0xff1abc9c,
      0xff2ecc71,
      0xff3498db,
      0xff9b59b6,
      0xff34495e,
      0xff16a085,
      0xff27ae60,
      0xff2980b9,
      0xff8e44ad,
      0xff2c3e50,
      0xfff1c40f,
      0xffe67e22,
      0xffe74c3c,
      0xff95a5a6,
      0xfff39c12,
      0xffd35400,
      0xffc0392b,
      0xffbdc3c7,
      0xff7f8c8d
    ];

    var abbr = _getAbbreviation(name);
    var index = abbr.hashCode.abs() % (colors.length - 1);

    if (abbr.isEmpty) {
      return ImagePlaceholder(abbr, Colors.white);
    }

    return ImagePlaceholder(abbr, Color(colors[index]));
  }

  static String _getAbbreviation(String data) {
    if (data == null || data.isEmpty) {
      return "";
    } else {
      return data
          .split(new RegExp('\\s+'))
          .take(2)
          .map((e) => e[0].toUpperCase())
          .join();
    }
  }
}
