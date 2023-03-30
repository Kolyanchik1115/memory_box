import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memory_box/blocs/create_collection_bloc/create_collection_bloc.dart';
import 'package:memory_box/pages/collection_page/main_collection_page/collection_page.dart';
import 'package:memory_box/pages/collection_page/select_audio_page/select_audio_page.dart';
import 'package:memory_box/pages/collection_page/widgets/green_edit_appbar.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/avatar_edit_widget.dart';
import 'package:memory_box/pages/profile_pages/profile_edit_page/widget/button_back_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:memory_box/widgets/circle_purple_appbar.dart';

import '../../../resources/app_icons.dart';
import '../../../widgets/item_track_widget.dart';
import '../select_audio_page/select_widget.dart';
import '../widgets/audioListWidget.dart';

class CreateNewCollectionPage extends StatelessWidget {
  const CreateNewCollectionPage({super.key});

  static const routeName = '/create_new_collection_page/create_new_collection_page';

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final nameFocusNode = FocusNode();
    return BlocBuilder<CreateCollectionBloc, CreateCollectionState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              leading: ButtonBackWidget(onTap: () {
                Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
              }),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: width / 5,
              centerTitle: true,
              title: Text(
                'Создание',
                style: AppTextStyles.white36,
              ),
              actions: [
                TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    context.read<CreateCollectionBloc>().add(
                          CreateCollectionSaveEvent(),
                        );

                    Navigator.pushNamedAndRemoveUntil(context, CollectionPage.routeName, (route) => false);
                    context.read<CreateCollectionBloc>().add(
                      CollectionInitialEvent(),);


                  },
                  child: Text(
                    'Готово',
                    style: AppTextStyles.white16,
                  ),
                ),
              ],
            ),
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                ClipPath(
                  clipper: Customshape(),
                  child: Container(
                    color: AppColors.green,
                    width: double.infinity,
                    height: height / 2.45,
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: height / 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: TextFormField(
                          initialValue: state.titleOfCollection,
                          textInputAction: TextInputAction.go,
                          onChanged: (value){
                            context.read<CreateCollectionBloc>()
                                  .add(CreateCollectionNameEvent(titleOfCollection: value));
                          },
                       
                          onEditingComplete: () {
                            nameFocusNode.unfocus();
                          },
    
                          style: AppTextStyles.white24,
                          cursorColor: AppColors.white,
                          decoration: InputDecoration(
                            hintText: 'Название',
                            hintStyle: AppTextStyles.white24,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    AvatarEditWidget(
                      height: height / 4,
                      width: width / 1.1,
                      onTap: () {
                        context.read<CreateCollectionBloc>().add(
                              CreateCollectionUploadImageEvent(),
                            );
                      },
                    ),
                    SizedBox(
                      width: width / 1.1,
                      child: TextFormField(
                        initialValue: state.descriptionOfAudio,
                        onChanged: (value){
                          context.read<CreateCollectionBloc>().add(
                            CreateCollectionDescriptionEvent(descriptionOfCollection: value ),
                          );
                        },
                        onEditingComplete: () {
                          nameFocusNode.unfocus();
                        },
                        textInputAction: TextInputAction.go,
                        // controller: controllerDescription,
                        style: AppTextStyles.black14,
                        maxLines: 3,
                        cursorColor: AppColors.grey,
                        decoration: InputDecoration(
                          labelText: 'Введите описание...',
                          labelStyle: AppTextStyles.black14,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.black.withOpacity(0.2)),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.8, -0.5),
                      child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: Text(
                          'Готово',
                          style: AppTextStyles.black16,
                        ),
                      ),
                    ),
                    if (state.audioModels.isEmpty) ...[
                      Expanded(
                        child: Center(
                          child: TextButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context, SelectAudioPage.routeName);
                            },
                            child: Text(
                              'Добавить аудиофайл',
                              style: TextStyle(
                                shadows: [Shadow(color: AppColors.black, offset: const Offset(0, -5))],
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.black,
                                decorationThickness: 1,
                                fontFamily: AppFonts.fontFamily,
                                fontSize: 14,
                                color: Colors.transparent,
                                fontWeight: AppFonts.subtitle,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      const AudioListWidget(),
                    ],
                  ],
                ),
              ],
            ),
          );
        },
      );
  }
}
