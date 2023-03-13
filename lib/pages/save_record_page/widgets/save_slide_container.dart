import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/player/player_bloc.dart';
import 'package:memory_box/pages/save_to_collection_page/save_to_collection_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:memory_box/widgets/new_user_containers.dart/player_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SaveSlideContainer extends StatefulWidget {
  const SaveSlideContainer({
    super.key,
    required this.uuid,
  });

  final String uuid;

  @override
  State<SaveSlideContainer> createState() => _SaveSlideContainerState();
}

class _SaveSlideContainerState extends State<SaveSlideContainer> {
  final panelController = PanelController();

  @override
  initState() {
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
    return BlocBuilder<PlayerBloc, PlayersState>(
      builder: (context, state) {
        return SlidingUpPanel(
          controller: panelController,
          isDraggable: false,
          color: AppColors.white,
          maxHeight: 750,
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.white,
                      ),
                      onPressed: () async {
                        await Share.shareXFiles([
                          XFile(
                              '/data/user/0/com.example.memory_box/cache/audio.mp4')
                        ], text: 'Моя новая  сказка!');
                      },
                      child: SvgPicture.asset(AppIcons.upload)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.white,
                      ),
                      onPressed: () {},
                      child: SvgPicture.asset(AppIcons.paper)),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, backgroundColor: AppColors.white),
                      onPressed: () {},
                      child: SvgPicture.asset(AppIcons.delete)),
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: TextButton(
                      onPressed: () async {
                        if (isAuth()) {
                          context.read<PlayerBloc>().add(PlayerDownloadEvent());
                        } else {
                          await Navigator.pushNamedAndRemoveUntil(
                            context,
                            SaveToCollectionPage.routeName,
                            arguments: widget.uuid,
                            (route) => false,
                          );
                        }
                      },
                      child: Text(
                        'Сохранить',
                        style: AppTextStyles.black16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 152),
              Text(
                isAuth() ? 'Аудиозапись' : state.fileName,
                style: AppTextStyles.black26,
              ),
              const SizedBox(height: 99),
              AudioPlayerWidget(uuid: widget.uuid),
            ],
          ),
        );
      },
    );
  }
}
