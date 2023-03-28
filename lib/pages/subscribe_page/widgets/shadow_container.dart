import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/subscribe/subscribe_bloc.dart';
import 'package:memory_box/pages/subscribe_page/widgets/little_container.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

import 'package:memory_box/widgets/buttons/orange_recnagle_button.dart';

class BigShadowContainerWidgets extends StatefulWidget {
  const BigShadowContainerWidgets({super.key});

  @override
  State<BigShadowContainerWidgets> createState() =>
      _BigShadowContainerWidgetsState();
}

class _BigShadowContainerWidgetsState extends State<BigShadowContainerWidgets> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 1.04,
      height: height / 1.52,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 4,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ], borderRadius: BorderRadius.circular(25), color: AppColors.white),
      child: Column(
        children: [
          SizedBox(height: height / 50),
          Text(
            'Выбери подписку',
            style: AppTextStyles.black24,
          ),
          SizedBox(height: height / 50),
          const LittleShadowContainerWidgets(),
          SizedBox(height: height / 40),
          Padding(
            padding: EdgeInsets.only(right: width / 6),
            child: Text(
              'Что дает подписка:',
              style: AppTextStyles.black20,
            ),
          ),
          SizedBox(height: height / 40),
          Padding(
            padding: EdgeInsets.only(right: width / 6),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width / 7.2),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.infinity),
                      const SizedBox(width: 11.69),
                      Text(
                        'Неограниченая память',
                        style: AppTextStyles.black14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: width / 7.2),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.cloud),
                      const SizedBox(width: 11.69),
                      Text(
                        'Все файлы хранятся в облаке',
                        style: AppTextStyles.black14,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(left: width / 7.2),
                  child: Row(
                    children: [
                      SvgPicture.asset(AppIcons.download),
                      const SizedBox(width: 11.69),
                      Flexible(
                        child: Text(
                          'Возможность скачивать без ограничений',
                          style: AppTextStyles.black14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height / 35),
          BlocBuilder<SubscribeBloc, SubscribeState>(
            builder: (context, state) {
              return OrangeRectangleButton(
                text: state.changeYear
                    ? 'Подписаться на месяц'
                    : 'Подписаться на год',
                onPressed: () {},
              );
            },
          )
        ],
      ),
    );
  }
}
