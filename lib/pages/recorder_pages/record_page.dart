import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/pages/recorder_pages/widgets/record_slide_container.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  static const routeName = '/recorder_pages/recorder_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading:
        IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: SvgPicture.asset(AppIcons.drawer)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: Customshape(),
            child: Container(
              color: AppColors.purple,
              width: double.infinity,
              height: 380,
            ),
          ),
          const RecordSlideContainer(),
        ],
      ),
    );
  }
}
