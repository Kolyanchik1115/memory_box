import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/navigation/navigation_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';

import 'package:memory_box/pages/deleted_page/deleted_page.dart';
import 'package:memory_box/pages/deleted_page/widgets/select_to_delete_item.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

import '../../utils/overlay_player.dart';
import '../save_record_page/widgets/rounded_circle_thumb_widget.dart';

class SelectToDeletePage extends StatefulWidget {
  const SelectToDeletePage({super.key});

  static const routeName = 'select_to_delete_page/select_to_delete_page';

  @override
  State<SelectToDeletePage> createState() => _SelectToDeletePageState();
}

class _SelectToDeletePageState extends State<SelectToDeletePage> {
  final controller = TextEditingController();
  bool isSelected = false;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      builder: (context, state) {
        final height = MediaQuery.of(context).size.height;
        Future<void> refresh() async {
          context.read<AudioListBloc>().add(AudioListInitialEvent());
        }

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 100,
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
                  color: AppColors.dartBlue,
                  width: double.infinity,
                  height: height / 2.8,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'Недавно',
                          textDirection: TextDirection.ltr,
                          style: AppTextStyles.white36,
                        ),
                      ),
                      Center(
                        child: Text(
                          'удаленные',
                          textDirection: TextDirection.ltr,
                          style: AppTextStyles.white36,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextButton(
                          onPressed: () {
                            context.read<NavigationBloc>().add(
                                  NavigateMenu(
                                    menuIndex: 9,
                                    route: DeletedPage.routeName,
                                  ),
                                );
                          },
                          child: Text(
                            'Отменить',
                            style: AppTextStyles.white16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 250),
                child: RefreshIndicator(
                  onRefresh: refresh,
                  color: AppColors.blue,
                  child: GroupedListView<dynamic, String>(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    elements: state.mapDeletedAudio,
                    groupBy: (element) => element['deleteTime'],
                    groupSeparatorBuilder: (groupByValue) => Container(
                      margin: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            groupByValue,
                            style: AppTextStyles.grey14,
                          )
                        ],
                      ),
                    ),
                    indexedItemBuilder: (context, dynamic element, index) {
                      return SelectDeletedItemWidget(
                        play: SvgPicture.asset(AppIcons.bluePlay),
                        pause: SvgPicture.asset(AppIcons.bluePause),
                        nameAudio: state.listDeletedAudio[index].titleOfAudio,
                        timeAudio: state.listDeletedAudio[index].timeOfAudio,
                        leftIcon: SvgPicture.asset(AppIcons.bluePlay),
                        rightIcon: SvgPicture.asset(AppIcons.notSelected),
                        index: index,
                        action: () {
                          context.read<PlayerBloc>().add(
                                PlayerInitOverlayEvent(
                                    state.audioList[index].path, state.audioList[index].titleOfAudio),
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
                        isActive: selectedIndex == index, id: '',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
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
