import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class VectorIcon extends StatelessWidget {
  final String _assetName;
  final double width;
  final double height;

  const VectorIcon(this._assetName, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return SvgPicture.asset(
      _assetName,
      color: iconTheme.color,
      width: width,
      height: height,
    );
  }
}
