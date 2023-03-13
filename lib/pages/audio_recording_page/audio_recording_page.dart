import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/audio_list/audio_list_bloc.dart';
import 'package:memory_box/pages/audio_recording_page/widgets/start_all_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_subscribe.dart';
import 'package:memory_box/widgets/audio_list_view_widget.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class AudioRecordingsPage extends StatefulWidget {
  const AudioRecordingsPage({super.key});

  static const routeName = '/audio_recordings_page/audio_recordings_page';

  @override
  State<AudioRecordingsPage> createState() => _AudioRecordingsPageState();
}

class _AudioRecordingsPageState extends State<AudioRecordingsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      builder: (context, state) {
        final height = MediaQuery.of(context).size.height;
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            toolbarHeight: 100,
            leading: IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: SvgPicture.asset(AppIcons.drawer),
            ),
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
                  const Center(
                    child: TitleAppBarSubscribe(
                      title: 'Аудиозаписи',
                      'Все в одном месте',
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.counterAudio} аудио',
                              style: AppTextStyles.white15,
                            ),
                            Text(
                              state.totalDuration,
                              style: AppTextStyles.white15,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 25),
                        child: StartAllWidget(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  AudioListViewWidget(
                    icon: SvgPicture.asset(AppIcons.bluePlay),
                    iconPlay: SvgPicture.asset(AppIcons.bluePlay),
                    iconPause: SvgPicture.asset(AppIcons.bluePause),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
