import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/collection/collection_bloc.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

import '../../../blocs/create_collection_bloc/create_collection_bloc.dart';
import '../main_collection_page/collection_page.dart';

class ItemAudioWidget extends StatefulWidget {
  const ItemAudioWidget({
    super.key,
    required this.nameAudio,
    required this.timeAudio,
    required this.index,
    required this.action,
    required this.isActive,
    required this.iconPause,
    required this.iconPlay,
    required this.uuid,
    required this.audioId,
  });

  final String nameAudio;
  final String timeAudio;

  final SvgPicture iconPause;
  final SvgPicture iconPlay;

  final int index;
  final VoidCallback action;
  final bool isActive;
  final String uuid;
  final String audioId;

  @override
  State<ItemAudioWidget> createState() => _ItemAudioWidgetState();
}

class _ItemAudioWidgetState extends State<ItemAudioWidget> {
  final dragController = DragController();
  bool rename = true;
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textEditingController = TextEditingController();

    function() {
      context.read<AudioListBloc>().add(AudioListItemRemoveInNewFolderEvent());
      context.read<AudioListBloc>().add(AudioListInitialEvent());
    }

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
                    // print(widget.isActive);
                    print(state.isPlaying);

                    if (widget.isActive && state.status == PlayerStatus.play) {
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
                          icon: !playing ? widget.iconPlay : widget.iconPause,
                        ));
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
                              borderSide: BorderSide(color: AppColors.black),
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
                    ? popupMenu(widget.index, widget.uuid, function, widget.audioId)
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            context.read<AudioListBloc>().add(AudioListItemRenameEvent(
                                  titleOfAudio: textEditingController.text,
                                ));
                            rename = true;
                            Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
                          });
                        },
                        icon: SvgPicture.asset(AppIcons.galochka))),
          ],
        ),
      ),
    );
  }

  Widget popupMenu(int index, String uuid, VoidCallback function, String audioId) {
    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        return PopupMenuButton(
            constraints: const BoxConstraints.expand(width: 200, height: 160),
            offset: const Offset(0, 35),
            color: AppColors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            icon: SvgPicture.asset(AppIcons.littleTripleMenu),
            itemBuilder: (context) {
              context.read<AudioListBloc>().add(AudioListItemInteractionEvent(index, uuid));
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        rename = false;
                        context.read<AudioListBloc>().add(AudioListItemRenameEvent());
                        context
                            .read<CollectionBloc>()
                            .add(CollectionGetCardInitial(collectionAudioModel: state.collectionAudioModel));
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Переименовать',
                      style: AppTextStyles.black14,
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () async {
                      context.read<CollectionBloc>().add(DeleteAudioCollectionEvent(uuidAudio: audioId));
                      Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
                      context.read<CreateCollectionBloc>().add(CollectionInitialEvent());
                    },
                    child: Text(
                      'Удалить из подборки ',
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
      },
    );
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
                            border: Border.all(color: AppColors.purple, width: 1.5),
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
