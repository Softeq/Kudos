import 'package:flutter/material.dart';
import 'package:kudosapp/kudos_theme.dart';

class BottomDecorator extends StatelessWidget {
  final double width;

  BottomDecorator(this.width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: CustomPaint(
          painter: _BottomPainter(),
        ),
        height: 26,
        width: width);
  }
}

class _BottomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawFirstPart(canvas, size);
    _drawSecondPart(canvas, size);
  }

  void _drawFirstPart(Canvas canvas, Size size) {
    final x1 = size.width * 34.9 / 254.0;
    final x2 = size.width * 90.0 / 254.0;
    final x3 = size.width * 158.5 / 254.0;

    final y1 = size.height * 2.9 / 16.2;
    final y2 = size.height * -1.7 / 16.2;
    final y3 = size.height * 9.5 / 16.2;

    final path = Path()
      ..moveTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..lineTo(x3, size.height)
      ..lineTo(x1, size.height)
      ..close();

    final startColor = KudosTheme.mainGradientStartColor;
    final endColor = KudosTheme.mainGradientStartColor;
    final gradient = LinearGradient(
      colors: <Color>[
        startColor.withAlpha(125),
        endColor.withAlpha(125),
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
    final x2 = size.width * 53.3 / 254.0;
    final x3 = size.width * 113.0 / 254.0;
    final x4 = size.width * 224.2 / 254.0;
    final x5 = size.width * 254.0 / 254.0;

    final y1 = size.height * 0.0 / 16.2;
    final y2 = size.height * 3.4 / 16.2;
    final y3 = size.height * 15.6 / 16.2;
    final y4 = size.height * -1.3 / 16.2;
    final y5 = size.height * 0 / 16.2;

    final path = Path()
      ..moveTo(x1, y1)
      ..quadraticBezierTo(x2, y2, x3, y3)
      ..quadraticBezierTo(x4, y4, x5, y5)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    final paint = Paint()
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
