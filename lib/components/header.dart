import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.4;
    return CustomPaint(
        painter: HeaderPainter(color: Theme.of(context).primaryColor),
        size: Size.fromHeight(height));
  }
}

class HeaderPainter extends CustomPainter {
  final Color color;

  HeaderPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height - size.height / 6);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
