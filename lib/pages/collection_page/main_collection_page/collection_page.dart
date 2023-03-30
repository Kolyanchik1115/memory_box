import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:memory_box/blocs/collection/collection_bloc.dart';
import 'package:memory_box/blocs/create_collection_bloc/create_collection_bloc.dart';
import 'package:memory_box/pages/collection_page/create_new_collection_page/create_new_collection_page.dart';
import 'package:memory_box/pages/collection_page/main_collection_page/widgets/item_collection.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

import '../../../utils/helpers.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  static const routeName = '/collection_page/collection_page';

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      context.read<CreateCollectionBloc>().add(CollectionInitialEvent());
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final itemHeight = (height - kToolbarHeight - 24) / 2.9;
    final itemWidth = width / 2;
    return BlocBuilder<CreateCollectionBloc, CreateCollectionState>(
      builder: (context, state) {
        context.read<CreateCollectionBloc>().add(CollectionInitialEvent());
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                await Navigator.pushNamedAndRemoveUntil(context, CreateNewCollectionPage.routeName, (route) => false);
              },
              icon: SvgPicture.asset(AppIcons.plusButton),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: width / 5,
            centerTitle: true,
            title: Column(
              children: [
                Text(
                  'Подборки',
                  style: AppTextStyles.white36,
                ),
                Text(
                  'Все в одном месте',
                  style: AppTextStyles.white16,
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              ClipPath(
                clipper: Customshape(),
                child: Container(
                  color: AppColors.green,
                  width: double.infinity,
                  height: 370,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                    ),
                  ),
                  SizedBox(height: height * 0.13),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: refresh,
                    color: AppColors.green,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: itemWidth / itemHeight,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                      ),
                      padding: const EdgeInsets.all(10),
                      itemCount: state.listCollectionModels.length,
                      itemBuilder: (context, index) {
                        // context.read<CreateCollectionBloc>().add(CollectionInitialEvent());
                        return ItemCollection(
                          pathToImage: state.listCollectionModels[index].pathToImage,
                          titleOfCollection: state.listCollectionModels[index].titleOfCollection,
                          counterAudio: state.listCollectionModels[index].idAudioModels.length.toString(),
                          totalDuration: totalDurationSeconds(state.listCollectionModels[index].allTimeAudioCollection),
                          onTap: () {
                            context.read<CollectionBloc>().add(CollectionGetCardInitial(collectionAudioModel: state.listCollectionModels[index]));
                          },
                        );
                      },
                    ),
                  )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
