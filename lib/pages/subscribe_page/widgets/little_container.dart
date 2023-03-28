import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/subscribe/subscribe_bloc.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class LittleShadowContainerWidgets extends StatefulWidget {
  const LittleShadowContainerWidgets({
    super.key,
  });

  @override
  State<LittleShadowContainerWidgets> createState() =>
      _LittleShadowContainerWidgetsState();
}

class _LittleShadowContainerWidgetsState
    extends State<LittleShadowContainerWidgets> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<SubscribeBloc, SubscribeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: width / 2.5,
              height: height / 4,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.white),
              child: Column(
                children: [
                  SizedBox(height: height / 20),
                  Text('300', style: AppTextStyles.black24),
                  const SizedBox(height: 10),
                  Text('в месяц', style: AppTextStyles.black16),
                  SizedBox(height: height / 20),
                  IconButton(
                    onPressed: () {
                      if (!state.changeYear) {
                        context.read<SubscribeBloc>().add(
                            ChangeSubscribeEvent(changeSub: state.changeYear));
                      }
                    },
                    icon: state.changeYear
                        ? SvgPicture.asset(AppIcons.ok)
                        : SvgPicture.asset(AppIcons.notOk),
                  ),
                ],
              ),
            ),
            Container(
              width: width / 2.5,
              height: height / 4,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.white),
              child: Column(
                children: [
                  SizedBox(height: height / 20),
                  Text('1800', style: AppTextStyles.black24),
                  const SizedBox(height: 10),
                  Text('в год', style: AppTextStyles.black16),
                  SizedBox(height: height / 20),
                  IconButton(
                    onPressed: () {
                      if (state.changeYear) {
                        context.read<SubscribeBloc>().add(
                            ChangeSubscribeEvent(changeSub: state.changeYear));
                      }
                    },
                    icon: !state.changeYear
                        ? SvgPicture.asset(AppIcons.ok)
                        : SvgPicture.asset(AppIcons.notOk),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
