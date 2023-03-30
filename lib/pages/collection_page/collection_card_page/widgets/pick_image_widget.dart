import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/blocs/create_collection_bloc/create_collection_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';

import '../../../../blocs/collection/collection_bloc.dart';

class PickImageWidget extends StatefulWidget {
  final double width;
  final double height;
  final VoidCallback onTap;

  const PickImageWidget({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  String? imagePath;
  XFile? image;
  File? newImage;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.grey,
                image: DecorationImage(
                  image: NetworkImage(
                    state.pathToImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.camera,
                  height: 80,
                  width: 80,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// SvgPicture.asset(AppIcons.camera)
// Future<void> pickMedia() async {
//   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
//   if (file != null) {
//     imagePath = file.path;
//     context.read<CreateCollectionBloc>().add(
//           CreateCollectionNameEvent(pathToImage: imagePath),
//         );
//     print(imagePath);
//     print(imagePath.runtimeType);
//     setState(() {});
//   }
// }
}
