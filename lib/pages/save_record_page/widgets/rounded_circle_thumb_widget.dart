import 'package:flutter/material.dart';

class RoundedCircleThumbWidget extends SliderComponentShape {
  final double radius;
  final Color color;

  const RoundedCircleThumbWidget({required this.radius, required this.color});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final canvas = context.canvas;

    final paint = Paint()..color = color;

    final rect = RRect.fromRectAndRadius(
      Rect.fromPoints(
        Offset(center.dx - 8.0, center.dy + 4.0),
        Offset(center.dx + 8.0, center.dy - 4.0),
      ),
      Radius.circular(radius + 5.0),
    );

    canvas.drawRRect(rect, paint);
  }
}


class CustomSliderThumbShape extends SliderComponentShape {
  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow}) {
    Offset dropOffset = Offset(
      center.dx - 11,
      center.dy - 5,
    );
    Path path = Path();
    // path_0.moveTo(16.7169,1.875);
    path.moveTo(
        dropOffset.dx+16.7169,
        dropOffset.dy+1.875
    );
    path.cubicTo(
        dropOffset.dx + 14.8284,
        dropOffset.dy + 0.9375,
        dropOffset.dx + 12.9398,
        dropOffset.dy,
        dropOffset.dx + 11,
        dropOffset.dy
    );
    path.cubicTo(
        dropOffset.dx + 9.06018,
        dropOffset.dy,
        dropOffset.dx + 7.17162,
        dropOffset.dy + 0.9375,
        dropOffset.dx + 5.28307,
        dropOffset.dy + 1.875
    );
    path.cubicTo(
        dropOffset.dx + 3.53559,
        dropOffset.dy + 2.74247,
        dropOffset.dx + 1.7881,
        dropOffset.dy + 3.60994,
        dropOffset.dx,
        dropOffset.dy + 3.7347
    );
    path.lineTo(
        dropOffset.dx,
        dropOffset.dy + 6.2653
    );
    path.cubicTo(
        dropOffset.dx + 1.7881,
        dropOffset.dy + 6.39006,
        dropOffset.dx + 3.53558,
        dropOffset.dy + 7.25753,
        dropOffset.dx + 5.28307,
        dropOffset.dy + 8.125
    );
    path.cubicTo(
        dropOffset.dx + 7.17162,
        dropOffset.dy + 9.0625,
        dropOffset.dx + 9.06018,
        dropOffset.dy + 10,
        dropOffset.dx + 11,
        dropOffset.dy + 10
    );
    path.cubicTo(
        dropOffset.dx + 12.9398,
        dropOffset.dy + 10,
        dropOffset.dx + 14.8284,
        dropOffset.dy + 9.0625,
        dropOffset.dx + 16.7169,
        dropOffset.dy + 8.125);
    path.cubicTo(
        dropOffset.dx + 18.4644,
        dropOffset.dy + 7.25753,
        dropOffset.dx + 20.2119,
        dropOffset.dy + 6.39007,
        dropOffset.dx + 22,
        dropOffset.dy + 6.2653);
    path.lineTo(
        dropOffset.dx + 22,
        dropOffset.dy + 3.7347
    );
    path.cubicTo(
        dropOffset.dx + 20.2119,
        dropOffset.dy + 3.60994,
        dropOffset.dx + 18.4644,
        dropOffset.dy + 2.74247,
        dropOffset.dx + 16.7169,
        dropOffset.dy + 1.875
    );
    path.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = sliderTheme.thumbColor as Color;
    context.canvas.drawPath(path, paint0Fill);
  }

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(22, 10);
}