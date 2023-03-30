import 'package:draggable_float_widget/draggable_float_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/blocs/search/search_bloc.dart';
import 'package:memory_box/pages/collection_page/create_new_collection_page/create_new_collection_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';
import 'package:memory_box/widgets/search_widget.dart';

import '../../../blocs/create_collection_bloc/create_collection_bloc.dart';

import '../../../resources/app_icons.dart';
import '../../../utils/overlay_player.dart';
import '../../deleted_page/widgets/select_to_delete_item.dart';
import '../../profile_pages/profile_edit_page/widget/button_back_widget.dart';
import '../../save_record_page/widgets/rounded_circle_thumb_widget.dart';

class SelectAudioPage extends StatefulWidget {
  SelectAudioPage({super.key});

  static const routeName = '/select_audio_page/select_audio_page';

  @override
  State<SelectAudioPage> createState() => _SelectAudioPageState();
}

class _SelectAudioPageState extends State<SelectAudioPage> {
  final controller = TextEditingController();
  int selectedIndex = -1;
  String id = '';
  List<String> getId = [];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => SearchBloc()..add(SearchInitEvent()),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: ButtonBackWidget(onTap: () {
                Navigator.pop(context);
              }),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: width / 5,
              centerTitle: true,
              title: Text(
                'Создание',
                style: AppTextStyles.white36,
              ),
              actions: [
                BlocBuilder<AudioListBloc, AudioListState>(
                  builder: (context, state) {
                    return TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        getId = state.selectedModelsId;

                        context.read<CreateCollectionBloc>().add(CreateCollectionAddAudioEvent(id: getId));
                        Navigator.pushNamed(context, CreateNewCollectionPage.routeName);
                      },
                      child: Text(
                        'Добавить',
                        style: AppTextStyles.white16,
                      ),
                    );
                  },
                ),
              ],
            ),
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                ClipPath(
                  clipper: Customshape(),
                  child: Container(
                    color: AppColors.green,
                    width: double.infinity,
                    height: 300,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.19,
                    ),
                    SearchWidget(
                      onChanged: (String value) {
                        context.read<AudioListBloc>().add(AudioListInitialEvent());
                        context.read<SearchBloc>().add(SearchFindEvent(enteredText: value));
                      },
                      controller: controller,
                    ),
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.audioList.length,
                        itemBuilder: (context, index) {
                          return UnconstrainedBox(
                              child: SelectDeletedItemWidget(
                            nameAudio: state.audioList[index].titleOfAudio,
                            timeAudio: state.audioList[index].timeOfAudio,
                            leftIcon: SvgPicture.asset(AppIcons.greenPlay),
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
                            isActive: selectedIndex == index,
                            play: SvgPicture.asset(AppIcons.greenPlay),
                            pause: SvgPicture.asset(AppIcons.greenPause),
                            id: state.audioList[index].id,
                          ));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  _showOverlay() {
    OverlayPlayer.removePreviousOverlay();
 
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
