import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';

import '../../../../blocs/collection/collection_bloc.dart';
import '../../../../resources/app_icons.dart';
import '../../collection_card_page/collection_card_page.dart';

class ItemCollection extends StatefulWidget {
  const ItemCollection({
    super.key,
    required this.pathToImage,
    required this.titleOfCollection,
    required this.counterAudio,
    required this.totalDuration,
    required this.onTap,
  });

  final String pathToImage;
  final String titleOfCollection;
  final String counterAudio;
  final String totalDuration;
  final Function onTap;

  @override
  State<ItemCollection> createState() => _ItemCollectionState();
}

class _ItemCollectionState extends State<ItemCollection> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        widget.onTap();
        Navigator.of(context).pushNamed(CollectionCardPage.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.grey,
          image: DecorationImage(
            image: NetworkImage(
              widget.pathToImage,
            ),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.titleOfCollection,
                style: AppTextStyles.white16w700,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.counterAudio} аудио',
                  style: AppTextStyles.white12,
                ),
                Text(widget.totalDuration, style: AppTextStyles.white12)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SelectItemCollection extends StatefulWidget {
  const SelectItemCollection({
    super.key,
    required this.pathToImage,
    required this.titleOfCollection,
    required this.counterAudio,
    required this.totalDuration,
    required this.onTap, required this.collectionId,
  });

  final String pathToImage;
  final String titleOfCollection;
  final String counterAudio;
  final String totalDuration;
  final Function onTap;
  final String  collectionId;

  @override
  State<SelectItemCollection> createState() => _SelectItemCollectionState();
}

class _SelectItemCollectionState extends State<SelectItemCollection> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  GestureDetector(
        onTap: () {
          widget.onTap();
          Navigator.of(context).pushNamed(CollectionCardPage.routeName);
        },
        //LinearGradient(
        //           colors: [Color(0xffe8e8e8), Color(0xff000000)],
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //         )
        //
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.grey,
                image: DecorationImage(
                  colorFilter: isSelected ? null : ColorFilter.mode(AppColors.grey, BlendMode.multiply),
                  image: NetworkImage(
                    widget.pathToImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      widget.titleOfCollection,
                      style: AppTextStyles.white16w700,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.counterAudio} аудио',
                        style: AppTextStyles.white12,
                      ),
                      Text((widget.totalDuration), style: AppTextStyles.white12)
                    ],
                  )
                ],
              ),
            ),
            Center(
              child: IconButton(
                iconSize: 50,
                onPressed: () {
                  context.read<CollectionBloc>().add(SelectCollection(collectionAddId: widget.collectionId));
                  setState(() {
                    if (isSelected) {
                      isSelected = false;
                    } else {
                      isSelected = true;
                    }
                  });
                },
                icon: isSelected ? SvgPicture.asset(AppIcons.pickOk) : SvgPicture.asset(AppIcons.pickNotOk),
              ),
            ),
          ],
        ),
      );

  }
}
