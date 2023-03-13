import 'package:flutter/material.dart';
import 'package:memory_box/pages/save_to_collection_page/widgets/save_to_collection_container.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class SaveToCollectionPage extends StatelessWidget {
  const SaveToCollectionPage({super.key, required this.uuid});

  static const routeName = '/save_to_collection_page/save_to_collection_page';
  final String uuid;

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
          SaveToCollectionContainer(
            uuid: uuid,
          ),
        ],
      ),
    );
  }
}
