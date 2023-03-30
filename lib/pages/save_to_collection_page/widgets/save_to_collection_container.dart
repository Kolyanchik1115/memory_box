import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/pages/home_page/home_page.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_images.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/new_user_containers.dart/player_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SaveToCollectionContainer extends StatefulWidget {
  const SaveToCollectionContainer({
    super.key,
    required this.uuid,
  });

  final String uuid;

  @override
  State<SaveToCollectionContainer> createState() =>
      _SaveToCollectionContainerState();
}

class _SaveToCollectionContainerState extends State<SaveToCollectionContainer> {
  final textEditingController = TextEditingController();
  final panelController = PanelController();
  bool notEditable = true;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await panelController.open();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<PlayerBloc, PlayersState>(
      builder: (context, state) {
        return SlidingUpPanel(
          isDraggable: false,
          controller: panelController,
          color: AppColors.white,
          maxHeight: height * 0.95,
          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(25),
          panel: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 15),
                    child: notEditable
                        ? IconButton(
                            icon: SvgPicture.asset(AppIcons.okButton),
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  HomePage.routeName, (route) => false);
                            },
                          )
                        : TextButton(
                            onPressed: () {},
                            child: Text(
                              'Отменить',
                              style: AppTextStyles.black14,
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 15),
                    child: notEditable
                        ? popupMenu()
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                notEditable = true;
                                context
                                    .read<PlayerBloc>()
                                    .add(PlayerRenameEvent(
                                      uuid: widget.uuid,
                                      titleOfAudio: textEditingController.text,
                                    ));
                              });
                            },
                            child: Text(
                              'Готово',
                              style: AppTextStyles.black14,
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Container(
                width: width / 1,
                height: height / 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.white),
                child: Image.asset(AppImages.saveAudio),
              ),
              const SizedBox(height: 20),
              if (notEditable)
                const NameAudio()
              else
                SizedBox(
                  width: 213,
                  child: TextField(
                    controller: textEditingController,
                    onChanged: (text) => {},
                    style: AppTextStyles.black14,
                    cursorColor: AppColors.black,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                      ),
                    ),
                  ),
                ),
              AudioPlayerWidget(
                uuid: widget.uuid,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget popupMenu() {
    return PopupMenuButton(
      offset: const Offset(0, 35),
      color: AppColors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      icon: SvgPicture.asset(AppIcons.tripleMenu),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Добавить в подборку',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              setState(() {
                notEditable = false;
                Navigator.pop(context);
              });
            },
            child: Text(
              'Редактировать название',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () async {
              await Share.shareXFiles([
                XFile(
                    '/data/user/0/com.example.memory_box/cache/Аудиозапись.mp4')
              ], text: 'Моя новая  сказка!');
            },
            child: Text(
              'Поделиться',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Скачать',
              style: AppTextStyles.black14,
            ),
          ),
        ),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Удалить',
              style: AppTextStyles.black14,
            ),
          ),
        ),
      ],
    );
  }
}

class NameAudio extends StatelessWidget {
  const NameAudio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayersState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Название подборки',
              style: AppTextStyles.black24,
            ),
            const SizedBox(height: 18),
            Text(
              state.fileName.toString(),
              style: AppTextStyles.black14,
            ),
          ],
        );
      },
    );
  }
}
