import 'package:flutter/material.dart';

import 'package:memory_box/pages/save_record_page/widgets/save_slide_container.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class SaveRecordPage extends StatelessWidget {
  const SaveRecordPage({
    super.key,
    required this.uuid,
  });

  final String uuid;

  static const routeName = '/save_record_page/save_record_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
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
          SaveSlideContainer(uuid: uuid),
        ],
      ),
    );
  }
}
