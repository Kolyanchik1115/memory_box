import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/pages/subscribe_page/widgets/shadow_container.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_subscribe.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

class SubscribePage extends StatelessWidget {
  const SubscribePage({super.key});

  static const routeName = '/subscribe_page/subscribe_page';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
              color: AppColors.purple,
              width: double.infinity,
              height: height / 2.45,
            ),
          ),
          Column(
            children: [
              SizedBox(height: height / 13),
              const Center(
                child: TitleAppBarSubscribe(
                  title: 'Подписка',
                  'Расширь возможности',
                ),
              ),
              SizedBox(height: height / 25),
              const BigShadowContainerWidgets(),
            ],
          ),
        ],
      ),
    );
  }
}
