import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class DrawerNavigation extends StatefulWidget {
  const DrawerNavigation({
    super.key,
    required this.onSelect,
    required this.currentTab,
  });

  final void Function(int) onSelect;
  final int currentTab;

  @override
  State<DrawerNavigation> createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  void _onChanged(int index) {
    widget.onSelect(index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: Drawer(
        backgroundColor: AppColors.white,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  Text('Аудиосказки', style: AppTextStyles.black24l),
                  const SizedBox(height: 40),
                  Text('Меню', style: AppTextStyles.grey22),
                  const SizedBox(height: 84),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: ItemDrawer(
                          icon: SvgPicture.asset(AppIcons.homeBlack),
                          title: 'Главная',
                          onPressed: () {
                            _onChanged(0);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: ItemDrawer(
                          icon: SvgPicture.asset(AppIcons.profile),
                          title: 'Профиль',
                          onPressed: () {
                            _onChanged(4);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: ItemDrawer(
                          icon: SvgPicture.asset(AppIcons.audioRecordings),
                          title: 'Все аудиофайлы',
                          onPressed: () {
                            _onChanged(3);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: ItemDrawer(
                          icon: SvgPicture.asset(AppIcons.search),
                          title: 'Поиск',
                          onPressed: () {
                            _onChanged(5);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        child: ItemDrawer(
                          icon: SvgPicture.asset(AppIcons.delete),
                          title: 'Недавно удаленные',
                          onPressed: () {
                            _onChanged(6);
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: ItemDrawer(
                          icon: SvgPicture.asset(AppIcons.wallet),
                          title: 'Подписка',
                          onPressed: () {
                            _onChanged(7);
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemDrawer extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  const ItemDrawer({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(title, style: AppTextStyles.black18),
    );
  }
}
