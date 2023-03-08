import 'package:flutter/cupertino.dart';
import 'package:memory_box/resources/app_colors.dart';

class RecordPainter extends CustomPainter {
  RecordPainter({
    required this.width,
    required this.value,
    required this.index,
  });

  final double width;
  final double value;
  final int index;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = AppColors.black;
    paint.strokeWidth = 3.0;
    paint.strokeCap = StrokeCap.square;
    paint.strokeMiterLimit = 80;

    final barValue = value / 2;

    canvas.drawLine(
      Offset(width * index, -barValue.ceilToDouble()),
      Offset(width * index, barValue.ceilToDouble()),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}