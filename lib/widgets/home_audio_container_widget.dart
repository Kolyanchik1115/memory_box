import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/audio_list_view_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../utils/helpers.dart';

class AudioContainer extends StatefulWidget {
  const AudioContainer({super.key});

  @override
  State<AudioContainer> createState() => _AudioContainerState();
}

class _AudioContainerState extends State<AudioContainer> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SlidingUpPanel(
      color: AppColors.white,
      maxHeight: height * 0.87,
      minHeight: height * 0.5,
      margin: const EdgeInsets.only(left: 10, right: 10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 5,
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      borderRadius: BorderRadius.circular(25),
      panel: BlocBuilder<AudioListBloc, AudioListState>(
        builder: (context, state) {
          return (state.audioList.isEmpty || isAuth())
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Аудиозаписи',
                            style: AppTextStyles.black22,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Открыть все',
                              style: AppTextStyles.black14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Text(
                      'Как только ты запишешь\nаудио, она появится здесь.',
                      style: AppTextStyles.grey20,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    SvgPicture.asset(AppIcons.down),
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Аудиозаписи',
                            style: AppTextStyles.black22,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Открыть все',
                              style: AppTextStyles.black14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AudioListViewWidget(
                      icon: SvgPicture.asset(AppIcons.bigPurplePlay),
                      iconPlay: SvgPicture.asset(AppIcons.bigPurplePlay),
                      iconPause: SvgPicture.asset(AppIcons.purplePause),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
        },
      ),
    );
  }
}
