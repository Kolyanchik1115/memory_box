import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';



class ItemTrackWidget extends StatefulWidget {
  const ItemTrackWidget({
    super.key,
    required this.nameAudio,
    required this.timeAudio,
    required this.index,
    required this.action,
    required this.isActive,
    required this.iconPause,
    required this.iconPlay,
    required this.uuid,
    required this.getId,
    required this.audioInSeconds,
    required this.path,
  });

  final String nameAudio;
  final String timeAudio;
  final String path;

  final SvgPicture iconPause;
  final SvgPicture iconPlay;

  final int index;
  final VoidCallback action;
  final bool isActive;
  final String uuid;
  final String getId;
  final int audioInSeconds;

  @override
  State<ItemTrackWidget> createState() => _ItemTrackWidgetState();
}

class _ItemTrackWidgetState extends State<ItemTrackWidget> {
  final dragController = DragController();
  bool rename = true;
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    TextEditingController textEditingController = TextEditingController();

    function() {
      context.read<AudioListBloc>().add(AudioListItemRemoveInNewFolderEvent());
      context.read<AudioListBloc>().add(AudioListInitialEvent());
    }

    return BlocConsumer<PlayerBloc, PlayersState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                        if (state.path == widget.path &&
                            state.status == PlayerStatus.play) {
                          playing = true;
                        } else {
                          playing = false;
                        }
                      },
                      builder: (context, state) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: IconButton(
                              iconSize: 45,
                              onPressed: widget.action,
                              icon:
                                  !playing ? widget.iconPlay : widget.iconPause,
                            )
                            // SvgPicture.asset(AppIcons.bluePlay),
                            );
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        if (rename)
                          Text(
                            widget.nameAudio,
                            style: AppTextStyles.black14,
                          )
                        else
                          SizedBox(
                            width: 150,
                            height: 18,
                            child: TextField(
                              controller: textEditingController,
                              style: AppTextStyles.black14,
                              cursorColor: AppColors.black,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.black),
                                ),
                              ),
                            ),
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
                    child: rename
                        ? popupMenu(widget.index, widget.uuid, function,
                            widget.getId, widget.audioInSeconds)
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                context
                                    .read<AudioListBloc>()
                                    .add(AudioListItemRenameEvent(
                                      titleOfAudio: textEditingController.text,
                                    ));
                                rename = true;
                              });
                            },
                            icon: SvgPicture.asset(AppIcons.galochka))

                  
                    ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget popupMenu(int index, String uuid, VoidCallback function, String getId,
      int audioInSeconds) {
    return PopupMenuButton(
        constraints: const BoxConstraints.expand(width: 200, height: 200),
        offset: const Offset(0, 35),
        color: AppColors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        icon: SvgPicture.asset(AppIcons.littleTripleMenu),
        itemBuilder: (context) {
          context
              .read<AudioListBloc>()
              .add(AudioListItemInteractionEvent(index, uuid));
          return [
            PopupMenuItem(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    rename = false;
                    context
                        .read<AudioListBloc>()
                        .add(AudioListItemRenameEvent());
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Переименовать',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
            // PopupMenuItem(
            //   child: BlocBuilder<CollectionBloc, CollectionState>(
            //     builder: (context, state) {
            //       return TextButton(
            //         onPressed: () async {
            //           context.read<CollectionBloc>().add(GetIdAudioEvent(
            //                 audioAddId: getId,
            //                 audioInSeconds: audioInSeconds,
            //               ));
            //           await Navigator.pushNamedAndRemoveUntil(context,
            //               SaveAudioToCollection.routeName, (route) => false);
            //         },
            //         child: Text(
            //           'Добавить в подборку',
            //           style: AppTextStyles.black14,
            //         ),
            //       );
            //     },
            //   ),
            // ),
            PopupMenuItem(
              child: TextButton(
                onPressed: () async {
                  // context.read<AudioListBloc>().add(AudioListItemRemoveInNewFolderEvent());
                  await showDialogDeleteAudio(function);
                  Navigator.pop(context);
                },
                child: Text(
                  'Удалить ',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
            PopupMenuItem(
              child: TextButton(
                onPressed: () async {
                  context.read<AudioListBloc>().add(AudioListItemShareEvent());
                  Navigator.pop(context);
                },
                child: Text(
                  'Поделиться',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ];
        });
  }

  Future<void> showDialogDeleteAudio(VoidCallback function) async {
    Function? onSelect;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            content: SizedBox(
              width: 320,
              height: 200,
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      textAlign: TextAlign.center,
                      'Подтверждаете удаление?',
                      style: AppTextStyles.red20,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ваш файл перенесется в папку\n “Недавно удаленные”.\nЧерез 15 дней он исчезнет.',
                    style: AppTextStyles.grey14,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          function();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 84,
                          height: 41,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(51),
                            ),
                            color: AppColors.purple,
                          ),
                          child: Center(
                            child: Text(
                              'Да',
                              style: AppTextStyles.white16,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 84,
                          height: 41,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(51),
                            ),
                            border:
                                Border.all(color: AppColors.purple, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              'Нет',
                              style: AppTextStyles.purple16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
