import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:share_plus/share_plus.dart';


class DeletedItemWidget extends StatefulWidget {
  const DeletedItemWidget({
    super.key,
    required this.nameAudio,
    required this.timeAudio,
    required this.index,
    required this.action,
    required this.isActive,
  });

  final String nameAudio;
  final String timeAudio;
  final int index;
  final VoidCallback action;
  final bool isActive;

  @override
  State<DeletedItemWidget> createState() => _DeletedItemWidgetState();
}

class _DeletedItemWidgetState extends State<DeletedItemWidget> {
  bool playing = false;
  bool rename = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Container(
        height: height * 0.08,
        width: width * 0.88,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(41),
            border: Border.all(
              color: AppColors.lightGrey,
            ),
            color: AppColors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 20,
              children: [
                BlocConsumer<PlayerBloc, PlayersState>(
                  listener: (context, state) {
                    if (widget.isActive && state.status == PlayerStatus.play) {
                      playing = true;
                    } else {
                      playing = false;
                    }
                  },
                  builder: (context, state) {
                    return Padding(padding: const EdgeInsets.only(left: 5), child: IconButton(
                      iconSize: 45,
                      onPressed: widget.action,
                      icon: !playing ? SvgPicture.asset(AppIcons.bluePlay): SvgPicture.asset(AppIcons.bluePause),
                    ));
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      widget.nameAudio,
                      style: AppTextStyles.black14,
                    ),
                    Text(
                      widget.timeAudio,
                      style: AppTextStyles.grey14,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                  onPressed: () {
                    context.read<AudioListBloc>().add(AudioListItemRemoveEvent());
                  },
                  icon: SvgPicture.asset(AppIcons.delete)),
            ),
          ],
        ),
      ),
    );
  }
}
