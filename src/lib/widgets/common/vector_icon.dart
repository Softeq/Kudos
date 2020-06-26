import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class VectorIcon extends StatelessWidget {
  final String _assetName;
  final Size size;

  const VectorIcon(this._assetName, [this.size]);

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return SvgPicture.asset(
      _assetName,
      color: iconTheme.color,
      width: size?.width,
      height: size?.height,
    );
  }
}
