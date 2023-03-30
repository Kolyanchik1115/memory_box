import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class CollectionManagementPage extends StatefulWidget {
  const CollectionManagementPage({super.key});

  static const routeName = '/collection_card_page/collection_management_page/';

  @override
  State<CollectionManagementPage> createState() => _CollectionManagementPageState();
}

class _CollectionManagementPageState extends State<CollectionManagementPage> {
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
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(state.titleOfCollection, style: AppTextStyles.white24),
                    ),
                  ),
                  SizedBox(
                    height: height / 50,
                  ),
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
                                  Text(totalDurationSeconds(state.allTimeAudioCollection), style: AppTextStyles.white14)
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                    width: width * 0.9,
                    child: Text(
                      state.descriptionOfCollection,
                      textAlign: TextAlign.center,
                      maxLines: readMore ? 10 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.black14,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  ),
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
                            id: '',
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
            onPressed: () {},
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
            onPressed: () {},
            child: Text(
              'Поделиться',
              style: AppTextStyles.black14,
            ),
          ),
        ),
      ],
    );
  }
}
