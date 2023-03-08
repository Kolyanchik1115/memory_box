// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:memory_box/resources/app_colors.dart';
// import 'package:memory_box/resources/app_icons.dart';

// class AvatarEditWidget extends StatefulWidget {
//   final double width;
//   final double height;
//   final VoidCallback onTap;

//   const AvatarEditWidget({
//     super.key,
//     required this.width,
//     required this.height,
//     required this.onTap,
//   });

//   @override
//   State<AvatarEditWidget> createState() => _AvatarEditWidgetState();
// }

// class _AvatarEditWidgetState extends State<AvatarEditWidget> {
//   String? imagePath;
//   XFile? image;

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return BlocBuilder<CreateCollectionBloc, CreateCollectionState>(
//       builder: (context, state) {
//         return Container(
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 4,
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           width: widget.width,
//           height: widget.height,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(24),
//             child: (state.image.isNotEmpty)
//                 ? Image.network(
//                     state.image,
//                     fit: BoxFit.fitWidth,
//                   )
//                 : ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.white.withOpacity(0.9),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(24),
//                         )),
//                     onPressed: widget.onTap,
//                     child: SizedBox(
//                       width: 80,
//                       height: 80,
//                       child: SvgPicture.asset(AppIcons.camera),
//                     ),
//                   ),
//           ),
//         );
//       },
//     );
//   }
// }
