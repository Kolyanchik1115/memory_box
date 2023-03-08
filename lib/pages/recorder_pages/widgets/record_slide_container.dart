import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/record/record_bloc.dart';

import 'package:memory_box/pages/recorder_pages/widgets/animated_rec_widget.dart';
import 'package:memory_box/pages/recorder_pages/widgets/record_painter_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RecordSlideContainer extends StatefulWidget {
  const RecordSlideContainer({
    super.key,
  });

  @override
  State<RecordSlideContainer> createState() => _RecordSlideContainerState();
}

class _RecordSlideContainerState extends State<RecordSlideContainer> {
  final String audio = 'Аудиозапись';
  final panelController = PanelController();
  int counter = 0;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        // await record();
        await panelController.open();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordBloc(),
      child: BlocConsumer<RecordBloc, RecordState>(
        listener: (context, state) {
          // Future.delayed(
          //   const Duration(milliseconds: 200),
          //   () async {
          //     if (state.status == RecorderStatus.finish) {
          //       context.read<PlayerBloc>().add(GetModelFromFirebase(
          //             state.uuid,
          //           ));
          //       Navigator.pushNamedAndRemoveUntil(
          //         context,
          //         SaveRecordPage.routeName,
          //         arguments: state.uuid,
          //         (route) => false,
          //       );
          //       // Navigator.of(context).pushNamedAndRemoveUntil(
          //       //   SaveRecordPage.routeName,
          //       //   arguments: state.uuid,
          //       // );
          //     }
          //   },
          // );
        },
        builder: (context, state) {
          counter = 0;
          return SlidingUpPanel(
            isDraggable: false,
            controller: panelController,
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
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Отменить',
                        style: AppTextStyles.black16,
                      ),
                    ),
                    const SizedBox(width: 29),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  'Запись',
                  style: AppTextStyles.black24,
                ),
                const SizedBox(height: 110),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 80,
                      width: state.noiseValues.length * 3.0,
                      child: (state.noiseValues != [])
                          ? Row(
                              children: state.noiseValues.map((double? number) {
                              counter++;
                              return CustomPaint(
                                painter: RecordPainter(
                                  width: 3,
                                  value: number!,
                                  index: counter,
                                ),
                              );
                            }).toList())
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 75),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: (state.status == RecorderStatus.play)
                          ? const RecordIcon()
                          : const NotRecordIcon(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.timer,
                      style: AppTextStyles.black18,
                    ),
                  ],
                ),
                const SizedBox(height: 55),
                Container(
                  child: (state.status == RecorderStatus.play)
                      ? InkWell(
                          onTap: () async {
                            context
                                .read<RecordBloc>()
                                .add(RecorderStoppedEvent());
                          },
                          child: SvgPicture.asset(AppIcons.pause),
                        )
                      : InkWell(
                          onTap: () async {
                            context
                                .read<RecordBloc>()
                                .add(RecordStartedEvent());
                          },
                          child: SvgPicture.asset(AppIcons.play),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
