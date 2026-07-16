import 'dart:math';

import 'package:flutter/material.dart';

class GlobeWireframePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2DD4BF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;

    /// 🌐 دوائر عرض (Latitude)
    for (int i = -4; i <= 4; i++) {
      final r = radius * (1 - i.abs() * 0.12);
      canvas.drawCircle(center, r, paint..color = const Color(0xFF2DD4BF).withOpacity(0.4));
    }

    /// 🌐 دوائر طول (Longitude)
    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * 3.1416 / 180;

      final p1 = Offset(
        center.dx + radius * 0.9 * cos(angle),
        center.dy + radius * 0.9 * sin(angle),
      );

      final p2 = Offset(
        center.dx - radius * 0.9 * cos(angle),
        center.dy - radius * 0.9 * sin(angle),
      );

      canvas.drawLine(p1, p2, paint..color = const Color(0xFF0891B2).withOpacity(0.35));
    }

    /// 🌐 نقاط التقاطع (Nodes)
    final dotPaint = Paint()
      ..color = const Color(0xFF2DD4BF)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 18; i++) {
      final angle = (i * 20) * 3.1416 / 180;

      final dx = center.dx + radius * cos(angle);
      final dy = center.dy + radius * sin(angle);

      canvas.drawCircle(Offset(dx, dy), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}