import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 93, 245, 210)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * -0.1283333, size.height * 0.7042857);
    path_0.quadraticBezierTo(size.width * -0.4077417, size.height * 1.1513714,
        size.width * -0.1492500, size.height * 0.9664000);
    path_0.cubicTo(
        size.width * -0.0023667,
        size.height * 0.9875571,
        size.width * 0.1195250,
        size.height * 0.4262857,
        size.width * 0.4633333,
        size.height * 0.5357143);
    path_0.quadraticBezierTo(size.width * 0.6256500, size.height * 0.6106143,
        size.width * 0.7841667, size.height * 0.3200000);
    path_0.lineTo(size.width * 1.0420250, size.height * -0.0586000);
    path_0.lineTo(size.width * 0.0025000, size.height * -0.1485714);

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1 outline
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02 // Increased stroke width for visibility
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}