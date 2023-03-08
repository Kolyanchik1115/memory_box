import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/utils/helpers.dart';

class Avatar extends StatelessWidget {
  final Color color;
  final SvgPicture icon;

  const Avatar({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 3.9,
      width: width / 1.8,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 4,
          blurRadius: 10,
          offset: const Offset(0, 4), // changes position of shadow
        ),
      ], borderRadius: BorderRadius.circular(24), color: color),
      child: Center(
        child: (checkAvatar())
            ? icon
            : Container(
                height: height / 3.9,
                width: width / 1.8,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.white,
                  image: DecorationImage(
                    image: NetworkImage(
                        FirebaseAuth.instance.currentUser!.photoURL!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      ),
    );
  }
}
