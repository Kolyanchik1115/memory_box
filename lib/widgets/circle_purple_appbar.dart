import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class PurpleAppBar extends StatelessWidget {
  final SvgPicture? icon = SvgPicture.asset(AppIcons.menu);
  final String? title;
  final String? subtitle;

  PurpleAppBar({
    super.key,
    this.title = '',
    this.subtitle = '',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const CustomPaint(
          size: Size(724, 426 * 0.8913043478260869),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(title ?? '', style: AppTextStyles.title),
            Text(
              subtitle ?? '',
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ],
    );
  }
}

class Customshape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 100)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 50)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;
    final path = Path()
      ..lineTo(0, size.height - 100)
      ..quadraticBezierTo(
          size.width / 2, size.height, size.width, size.height - 50)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
