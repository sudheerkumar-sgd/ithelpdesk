import 'package:flutter/material.dart';

class TooltipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF0E2A47)
      ..style = PaintingStyle.fill;

    const double radius = 5;
    const double arrowHeight = 5;
    const double arrowWidth = 8;
    const double bottomOffset = 3;

    final Path path = Path();

    // Rounded rectangle
    path.addRRect(RRect.fromLTRBR(
      size.width > 40 ? 10 : 0,
      0,
      size.width - (size.width > 40 ? 10 : 0),
      size.height + bottomOffset - arrowHeight,
      const Radius.circular(radius),
    ));

    // Arrow bottom center
    path.moveTo(size.width / 2 - arrowWidth / 2,
        size.height + bottomOffset - arrowHeight);
    path.lineTo(size.width / 2, size.height + bottomOffset);
    path.lineTo(size.width / 2 + arrowWidth / 2,
        size.height + bottomOffset - arrowHeight);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
