import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';

class RecordIcon extends StatefulWidget{
  const RecordIcon({super.key});

  @override
  _RecordIconState createState() => _RecordIconState();
}
class _RecordIconState extends State<RecordIcon> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation _colorAnimation;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _colorAnimation = ColorTween(begin: AppColors.white, end: AppColors.red)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
      setState(() {});
    });
    _controller.forward();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return  Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                  color: _colorAnimation.value,),
            );
      },
    );
  }
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NotRecordIcon extends StatelessWidget {
  const NotRecordIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(100),
        ),
        color: AppColors.grey),
    );
  }
}
