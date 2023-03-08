import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';

class CustomBNBar extends StatefulWidget {
  const CustomBNBar({
    super.key,
    required this.onSelect,
    required this.currentTab,
  });

  final void Function(int) onSelect;
  final int currentTab;

  @override
  State<CustomBNBar> createState() => _CustomBNBarState();
}

class _CustomBNBarState extends State<CustomBNBar> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.zero,
          height: h / 9,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 50,
                blurRadius: 100,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            color: AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox.shrink(),
              ItemButton(
                title: 'Главная',
                onPressed: () {
                  widget.onSelect(0);
                },
                asset: AppIcons.homeBlack,
                isActive: widget.currentTab == 0,
              ),
              const SizedBox.shrink(),
              ItemButton(
                title: 'Подборки',
                onPressed: () {
                  widget.onSelect(1);
                },
                asset: AppIcons.collection,
                isActive: widget.currentTab == 1,
              ),
              const SizedBox(width: 70),
              ItemButton(
                title: 'Аудиозаписи',
                onPressed: () async {
                  // AudioId.audioIdList = [];
                  widget.onSelect(3);
                },
                asset: AppIcons.audioRecordings,
                isActive: widget.currentTab == 3,
              ),
              const SizedBox.shrink(),
              ItemButton(
                title: 'Профиль',
                onPressed: () {
                  widget.onSelect(4);
                },
                asset: AppIcons.profile,
                isActive: widget.currentTab == 4,
              ),
              const SizedBox.shrink(),
            ],
          ),
        ),
        Positioned(
          bottom: h / 43,
          left: w / 2.477,
          child: ItemRecordButton(
            title: 'Запись',
            onPressed: () {
              widget.onSelect(2);
            },
            isActive: widget.currentTab == 2,
          ),
        ),
      ],
    );
  }
}

class ItemRecordButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isActive;

  const ItemRecordButton({
    super.key,
    required this.onPressed,
    required this.isActive,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 60,
            width: 80,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: isActive ? null : onPressed,
              icon: isActive
                  ? SvgPicture.asset(
                      AppIcons.recorderPipka,
                      color: AppColors.orange,
                    )
                  : Column(
                      children: [
                        Text('', style: AppTextStyles.white11),
                        SvgPicture.asset(AppIcons.record),
                      ],
                    ),
            ),
          ),
          Text(
            title,
            style: isActive ? AppTextStyles.white1 : AppTextStyles.orange10,
          ),
        ],
      ),
    );
  }
}

class ItemButton extends StatelessWidget {
  final String title;
  final String asset;
  final VoidCallback onPressed;
  final bool isActive;

  const ItemButton({
    super.key,
    required this.title,
    required this.asset,
    required this.onPressed,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: isActive ? null : onPressed,
          icon: SvgPicture.asset(
            asset,
            color: isActive ? AppColors.purple : AppColors.black,
          ),
        ),
        Text(
          title,
          style: isActive ? AppTextStyles.purple10 : AppTextStyles.black10,
        ),
      ],
    );
  }
}

class ButtonOrange extends StatelessWidget {
  const ButtonOrange({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      height: 46,
      width: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.orange,
      ),
    );
  }
}
