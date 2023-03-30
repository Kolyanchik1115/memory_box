import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/create_collection_bloc/create_collection_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_icons.dart';
import '../../../resources/app_text_styles.dart';
import '../../../utils/overlay_player.dart';
import '../../save_record_page/widgets/rounded_circle_thumb_widget.dart';
import '../select_audio_page/select_widget.dart';

class AudioListWidget extends StatefulWidget {
  const AudioListWidget({super.key});

  @override
  State<AudioListWidget> createState() => _AudioListWidgetState();
}

class _AudioListWidgetState extends State<AudioListWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateCollectionBloc, CreateCollectionState>(
      builder: (context, state) {
        return Flexible(
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 50),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.audioModels.length,
              itemBuilder: (context, index) {
                return ItemAudioWidget(
                  nameAudio: state.audioModels[index].titleOfAudio,
                  timeAudio: state.audioModels[index].timeOfAudio,
                  index: index,
                  action: () {
                    context.read<PlayerBloc>().add(
                          PlayerInitOverlayEvent(state.audioModels[index].path, state.audioModels[index].titleOfAudio),
                        );
                    if (OverlayPlayer.showDraggableFloat) {
                      OverlayPlayer.removePreviousOverlay();
                      _showOverlay();
                    } else {
                      _showOverlay();
                    }
                    setState(() {
                      selectedIndex = index;
                      OverlayPlayer.showDraggableFloat = !OverlayPlayer.showDraggableFloat;
                    });
                  },
                  isActive: selectedIndex == index,
                  iconPause: SvgPicture.asset(AppIcons.greenPause),
                  iconPlay: SvgPicture.asset(AppIcons.greenPlay),
                  uuid: '',
                  audioId: state.audioModels[index].id,
                );
              }),
        );
      },
    );
  }

  _showOverlay() {
    // 1. remove previous overlay
    OverlayPlayer.removePreviousOverlay();
    // _removePreviousOverlay();
    // 2. show new overlay
    OverlayPlayer.overlayEntry = OverlayEntry(builder: (context) {
      return BlocBuilder<PlayerBloc, PlayersState>(
        builder: (context, state) {
          return DraggableFloatWidget(
            width: MediaQuery.of(context).size.width - 4,
            height: MediaQuery.of(context).size.height / 11,
            config: const DraggableFloatWidgetBaseConfig(
              initPositionYInTop: false,
              initPositionYMarginBorder: 50,
              borderTopContainTopBar: true,
              borderBottom: 100,
              borderRight: 2,
              borderLeft: 2,
            ),
            onTap: () => print('Drag onTap!'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: const LinearGradient(
                    colors: [Color(0xff8c84e2), Color(0xff6c689f)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 45,
                    onPressed: () async {
                      if (state.status == PlayerStatus.play) {
                        context.read<PlayerBloc>().add(PlayerPauseEvent());
                      } else {
                        context.read<PlayerBloc>().add(PlayerStartOverlayEvent());
                      }
                      // await audioPlayer.play(source);
                    },
                    icon:
                        SvgPicture.asset(state.status == PlayerStatus.play ? AppIcons.whitePause : AppIcons.whitePlay),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        textAlign: TextAlign.left,
                        state.fileName,
                        style: AppTextStyles.white14,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            overlayShape: SliderComponentShape.noOverlay,
                            overlayColor: Colors.transparent,
                            trackShape: const RectangularSliderTrackShape(),
                            thumbShape: CustomSliderThumbShape(),
                            trackHeight: 3.5,
                            thumbColor: AppColors.white,
                            inactiveTrackColor: AppColors.white,
                            activeTrackColor: AppColors.white,
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
                              style: AppTextStyles.white10Opacity,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                            ),
                            Text(
                              state.durationView,
                              style: AppTextStyles.white10Opacity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      selectedIndex = -1;
                      OverlayPlayer.removePreviousOverlay();
                    },
                    icon: SvgPicture.asset(AppIcons.cross),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });

    Overlay.of(context).insert(OverlayPlayer.overlayEntry!);
  }
}
