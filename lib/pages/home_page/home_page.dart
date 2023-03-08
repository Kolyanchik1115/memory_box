import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/widgets/appbar_title_widgets/title_appbar.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';
import 'package:memory_box/widgets/new_user_containers.dart/new_user_container.dart';

import '../../utils/helpers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = 'new_user_home_page';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async => isAuth()
                ? showDialogAcc(context)
                : Scaffold.of(context).openDrawer(),
            icon: SvgPicture.asset(AppIcons.drawer)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height / 8),
              const TitleAppbarHomePage(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // if (state.listCollectionModels.isNotEmpty)
                  //   SizedBox(
                  //     height: height * 0.27,
                  //     width: width * 0.43,
                  //     child: ItemCollection(
                  //       pathToImage: state.listCollectionModels[0].pathToImage,
                  //       titleOfCollection:
                  //           state.listCollectionModels[0].titleOfCollection,
                  //       counterAudio: state
                  //           .listCollectionModels[0].idAudioModels.length
                  //           .toString(),
                  //       totalDuration: totalDurationSeconds(state
                  //           .listCollectionModels[0].allTimeAudioCollection),
                  //       onTap: () {
                  //         context.read<CollectionBloc>().add(
                  //             CollectionGetCardInitial(
                  //                 collectionAudioModel:
                  //                     state.listCollectionModels[0]));
                  //       },
                  //     ),
                  //   )
                  // else
                  const GreenRectangleWidget(),
                  Column(
                    children: [
                      // if (state.listCollectionModels.length > 1)
                      //   SizedBox(
                      //     height: height * 0.13,
                      //     width: width * 0.45,
                      //     child: ItemCollection(
                      //       pathToImage: state.listCollectionModels[1].pathToImage,
                      //       titleOfCollection: state.listCollectionModels[1].titleOfCollection,
                      //       counterAudio: state.listCollectionModels[1].idAudioModels.length.toString(),
                      //       totalDuration: totalDurationSeconds(state.listCollectionModels[1].allTimeAudioCollection),
                      //       onTap: () {
                      //         context.read<CollectionBloc>().add(
                      //             CollectionGetCardInitial(collectionAudioModel: state.listCollectionModels[1]));
                      //       },
                      //     ),
                      //   )
                      // else
                      const OrangeRectangleWidget(),
                      SizedBox(height: height / 70),
                      // if(state.listCollectionModels.length > 2)
                      //   SizedBox(
                      //     height: height * 0.13,
                      //     width: width * 0.45,
                      //     child: ItemCollection(
                      //       pathToImage: state.listCollectionModels[2].pathToImage,
                      //       titleOfCollection: state.listCollectionModels[2].titleOfCollection,
                      //       counterAudio: state.listCollectionModels[2].idAudioModels.length.toString(),
                      //       totalDuration: totalDurationSeconds(state.listCollectionModels[2].allTimeAudioCollection),
                      //       onTap: () {
                      //         context.read<CollectionBloc>().add(
                      //             CollectionGetCardInitial(collectionAudioModel: state.listCollectionModels[2]));
                      //       },
                      //     ),
                      //   ) else
                      const BlueRectangleWidget(),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // const AudioContainer(),
        ],
      ),
    );
  }
}
