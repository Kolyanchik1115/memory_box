import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/pages/save_record_page/widgets/rounded_circle_thumb_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({
    super.key,
    required this.uuid,
  });

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayersState>(
      builder: (context, state) {
        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                overlayColor: Colors.transparent,
                trackShape: const RectangularSliderTrackShape(),
                thumbShape: CustomSliderThumbShape(),
                trackHeight: 3.5,
                thumbColor: AppColors.black,
                inactiveTrackColor: AppColors.black,
                activeTrackColor: AppColors.black,
              ),
              child: Slider(
                min: 0,
                max: state.duration.inSeconds.toDouble(),
                value: state.position.inSeconds.toDouble(),
                onChanged: (value) async {
                  context.read<PlayerBloc>().add(PlayerPositionEvent(value));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.positionView,
                    style: AppTextStyles.black16,
                  ),
                  Text(
                    state.durationView,
                    style: AppTextStyles.black16,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () {
                    context.read<PlayerBloc>().add(PlayerBackEvent());
                  },
                  child: SvgPicture.asset(AppIcons.seekPlus),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.white,
                    ),
                    child: SvgPicture.asset(state.status == PlayerStatus.play
                        ? AppIcons.pause
                        : AppIcons.play),
                    onPressed: () async {
                      if (state.status == PlayerStatus.play) {
                        context.read<PlayerBloc>().add(PlayerPauseEvent());
                      } else {
                        context.read<PlayerBloc>().add(PlayerStartEvent(uuid));
                      }
                    }),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.white,
                  ),
                  onPressed: () async {
                    context.read<PlayerBloc>().add(PlayerForwardEvent());
                  },
                  child: SvgPicture.asset(AppIcons.seekMinus),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
