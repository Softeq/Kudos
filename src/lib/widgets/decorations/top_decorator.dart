import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';

class TopDecorator extends StatelessWidget {
  static const double height = 46;
  final double width;

  TopDecorator(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CustomPaint(
        painter: _TopPainter(),
      ),
      height: height,
      width: width,
    );
  }

  static Widget buildLayoutWithDecorator(Widget layout) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Positioned.fill(child: layout),
            Positioned.directional(
              textDirection: TextDirection.ltr,
              top: 0,
              child: TopDecorator(constraints.maxWidth),
            ),
          ],
        );
      },
    );
  }
}

class _TopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawFirstPart(canvas, size);
    _drawSecondPart(canvas, size);
    _drawThirdPart(canvas, size);
  }

  void _drawFirstPart(Canvas canvas, Size size) {
    final x1 = size.width * 0.0 / 254.0;
    final x2 = size.width * 52.4 / 254.0;
    final x3 = size.width * 115.0 / 254.0;
    final x4 = size.width * 115.0 / 254.0;

    final y1 = size.height * 27.0 / 27.0;
    final y2 = size.height * 24.0 / 27.0;
    final y3 = size.height * 14.5 / 27.0;
    final y4 = size.height * 0.0 / 27.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..lineTo(x4, y4)
      ..close();

    final startColor = KudosTheme.mainGradientStartColor;
    final endColor = KudosTheme.mainGradientEndColor;
    final gradient = LinearGradient(
      colors: <Color>[
        startColor.withAlpha(179),
        endColor.withAlpha(179),
      ],
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  void _drawSecondPart(Canvas canvas, Size size) {
    final x1 = size.width * 0.0 / 254.0;
    final x2 = size.width * 30.2 / 254.0;
    final x3 = size.width * 88.9 / 254.0;
    final x4 = size.width * 176.9 / 254.0;
    final x5 = size.width * 254.0 / 254.0;

    final y1 = size.height * 3.2 / 27.0;
    final y2 = size.height * 5.8 / 27.0;
    final y3 = size.height * 18.5 / 27.0;
    final y4 = size.height * 32.0 / 27.0;
    final y5 = size.height * 16.1 / 27.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..quadraticBezierTo(x4, y4, x5, y5)
      ..lineTo(size.width, 0.0)
      ..close();

    final startColor = KudosTheme.mainGradientStartColor;
    final endColor = KudosTheme.mainGradientEndColor;
    final gradient = LinearGradient(
      colors: <Color>[
        startColor.withAlpha(128),
        endColor.withAlpha(128),
      ],
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  void _drawThirdPart(Canvas canvas, Size size) {
    final x2 = size.width * 50.7 / 254.0;
    final x3 = size.width * 115.0 / 254.0;
    final x4 = size.width * 189.1 / 254.0;
    final x5 = size.width * 254.0 / 254.0;

    final y2 = size.height * 1.4 / 27.0;
    final y3 = size.height * 14.5 / 27.0;
    final y4 = size.height * 25.6 / 27.0;
    final y5 = size.height * 16.1 / 27.0;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..quadraticBezierTo(x4, y4, x5, y5)
      ..lineTo(size.width, 0.0)
      ..close();

    var paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = KudosTheme.mainGradient.createShader(
        Rect.fromLTWH(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
