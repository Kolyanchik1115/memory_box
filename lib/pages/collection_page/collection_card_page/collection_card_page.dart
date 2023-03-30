import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/blocs/collection/collection_bloc.dart';
import 'package:memory_box/pages/collection_page/collection_card_page/widgets/list_audio.dart';
import 'package:memory_box/pages/collection_page/collection_card_page/widgets/pick_image_widget.dart';
import 'package:memory_box/pages/collection_page/main_collection_page/collection_page.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/button_back_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

import '../../../blocs/create_collection_bloc/create_collection_bloc.dart';
import '../../../utils/helpers.dart';
import '../../deleted_page/widgets/select_to_delete_item.dart';
import '../../select_audio_to_collection/select_audio_to_collection.dart';

class CollectionCardPage extends StatefulWidget {
  const CollectionCardPage({super.key});

  static const routeName = '/collection_card_page/collection_card_page';

  @override
  State<CollectionCardPage> createState() => _CollectionCardPageState();
}

class _CollectionCardPageState extends State<CollectionCardPage> {
  bool update = true;
  bool readMore = false;
  bool notEditable = true;
  final nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<CollectionBloc, CollectionState>(
      builder: (context, state) {
        if (state.pathToImage.isEmpty) {
          return CircularProgressIndicator(
            color: AppColors.green,
          );
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: ButtonBackWidget(onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
            }),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: width / 5,
            centerTitle: true,
            actions: [
              popupMenu(),
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
                  height: height / 2.45,
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: height / 6.1,
                  ),
                  if (notEditable)
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(state.titleOfCollection, style: AppTextStyles.white24),
                      ),
                    )
                  else
                    Container(
                      height: 25,
                      padding: const EdgeInsets.only(left: 20, top: 8),
                      child: TextFormField(
                        initialValue: state.titleOfCollection,
                        textInputAction: TextInputAction.go,
                        onChanged: (value) {
                          context.read<CollectionBloc>().add(
                                ChangeTitleCollectionCardEvent(titleOfCollection: value),
                              );
                        },
                        onEditingComplete: nameFocusNode.unfocus,
                        style: AppTextStyles.white24,
                        cursorColor: AppColors.white,
                        decoration: InputDecoration(
                          hintText: state.titleOfCollection,
                          hintStyle: AppTextStyles.white24,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  if (notEditable)
                    SizedBox(
                      height: height / 50,
                    )
                  else
                    SizedBox(
                      height: height / 150,
                    ),
                  if (notEditable)
                    Container(
                      height: height / 4,
                      width: width / 1.1,
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
                      padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 2),
                            child: Text(
                              state.createTime,
                              style: AppTextStyles.white14,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.zero,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${state.counterAudio} аудио',
                                      style: AppTextStyles.white14,
                                    ),
                                    Text(totalDurationSeconds(state.allTimeAudioCollection),
                                        style: AppTextStyles.white14)
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.24,
                              ),
                              Container(
                                alignment: Alignment.bottomLeft,
                                height: height * 0.06,
                                width: width * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50), color: AppColors.grey.withOpacity(0.6)),
                                child: GestureDetector(
                                  onTap: () {
                                    // context.read<PlayerBloc>().add(PlayerGetModelEvent(listAudioModelsIds: state.collectionAudioModel.idAudioModels));
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(AppIcons.littleWhitePlay),
                                      Text(
                                        'Запустить все',
                                        style: AppTextStyles.white14,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    PickImageWidget(
                      height: height / 4,
                      width: width / 1.1,
                      onTap: () {
                        context.read<CollectionBloc>().add(ChangeImageCollectionCardEvent());
                      },
                    ),
                  SizedBox(height: height * 0.02),
                  if (notEditable)
                    SizedBox(
                      width: width * 0.9,
                      child: Text(
                        state.descriptionOfCollection,
                        textAlign: TextAlign.center,
                        maxLines: readMore ? 10 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.black14,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        maxLines: 6,
                        initialValue: state.descriptionOfCollection,
                        textInputAction: TextInputAction.go,
                        onChanged: (value) {
                          context
                              .read<CollectionBloc>()
                              .add(ChangeDescriptionCollectionCardEvent(descriptionOfCollection: value));
                        },
                        onEditingComplete: nameFocusNode.unfocus,
                        style: AppTextStyles.black14,
                        cursorColor: AppColors.white,
                        decoration: InputDecoration(
                          hintText: state.descriptionOfCollection,
                          hintStyle: AppTextStyles.black14,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (notEditable)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          readMore = !readMore;
                        });
                      },
                      child: Text(
                        key: ValueKey(readMore),
                        readMore ? 'Меньше' : 'Подробнее',
                        style: AppTextStyles.grey14,
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  if (update)
                    const ListAudio()
                  else
                    Flexible(
                      child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 50),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.audioIds.length,
                          itemBuilder: (context, index) {
                            return SelectDeletedItemWidget(
                              nameAudio: state.audioIds[index].titleOfAudio,
                              timeAudio: state.audioIds[index].timeOfAudio,
                              index: index,
                              leftIcon: SvgPicture.asset(AppIcons.greenPlay),
                              rightIcon: SvgPicture.asset(AppIcons.notSelected),
                              action: () {},
                              isActive: true,
                              play: SvgPicture.asset(AppIcons.greenPlay),
                              pause: SvgPicture.asset(AppIcons.greenPause),
                              id: state.audioIds[index].id,
                            );
                          }),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget popupMenu() {
    if (notEditable && update) {
      return PopupMenuButton(
        padding: EdgeInsets.only(right: 20),
        constraints: BoxConstraints.expand(
          width: 180,
          height: 200,
        ),
        offset: const Offset(-30, 45),
        color: AppColors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        icon: SvgPicture.asset(AppIcons.whiteTripleMenu),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    notEditable = false;
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Редактировать',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                setState(() {
                  update = false;
                  Navigator.pop(context);
                });
              },
              child: Text(
                'Выбрать несколько',
                style: AppTextStyles.black14,
              ),
            ),
          ),
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                context.read<CollectionBloc>().add(DeleteCollectionCardEvent());
                Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
              },
              child: Text(
                'Удалить подборку',
                style: AppTextStyles.black14,
              ),
            ),
          ),
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                context.read<CollectionBloc>().add(ShareCollectionCardEvent());
              },
              child: Text(
                'Поделиться',
                style: AppTextStyles.black14,
              ),
            ),
          ),
        ],
      );
    } else if (update == false && notEditable == true) {
      return PopupMenuButton(
        padding: EdgeInsets.only(right: 20),
        constraints: BoxConstraints.expand(
          width: 200,
          height: 250,
        ),
        offset: const Offset(-30, 45),
        color: AppColors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
        icon: SvgPicture.asset(AppIcons.whiteTripleMenu),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    update = true;
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Отменить выбор',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: SizedBox(
              child: TextButton(
                onPressed: () async {
                  await Navigator.pushNamedAndRemoveUntil(context, SaveAudioToCollection.routeName, (route) => false);
                },
                child: Text(
                  'Добавить в подборку',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  context.read<AudioListBloc>().add(AudioListShareCollectionEvent());
                },
                child: Text(
                  'Поделиться',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    update = false;
                    context.read<AudioListBloc>().add(AudioListDownloadCollectionEvent());
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  'Скачать',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            child: SizedBox(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    update = false;
                    context.read<AudioListBloc>().add(AudioListDeleteFromCollectionEvent());
                    Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
                  });
                },
                child: Text(
                  'Удалить',
                  style: AppTextStyles.black14,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return BlocBuilder<CollectionBloc, CollectionState>(
        builder: (context, state) {
          return PopupMenuButton(
            padding: EdgeInsets.only(right: 20),
            constraints: BoxConstraints.expand(
              width: 180,
              height: 60,
            ),
            offset: const Offset(-30, 45),
            color: AppColors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            icon: SvgPicture.asset(AppIcons.whiteTripleMenu),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: SizedBox(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        notEditable = true;
                        context.read<CollectionBloc>().add(SaveEditedCollectionCardEvent());
                        context.read<CreateCollectionBloc>().add(
                              CollectionInitialEvent(),
                            );
                        Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
                      });
                    },
                    child: Text(
                      'Готово',
                      style: AppTextStyles.black14,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
