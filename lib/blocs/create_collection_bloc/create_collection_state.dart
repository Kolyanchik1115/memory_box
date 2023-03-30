part of 'create_collection_bloc.dart';

@immutable
class CreateCollectionState {
  const CreateCollectionState({
    this.audioModel,
    this.id = '',
    this.titleOfCollection = '',
    this.image = '',
    this.descriptionOfAudio = '',
    this.createTime = '',
    this.allTimeAudioCollection = 0,
    this.idAudioModels = const [],
    this.collectionAudioModel,
    this.audioModels = const [],
    this.listCollectionModels = const [],
    this.ids = const [],
  });

  final String id;
  final String titleOfCollection;
  final String image;
  final String descriptionOfAudio;
  final String createTime;
  final int allTimeAudioCollection;
  final List idAudioModels;
  final CollectionAudioModel? collectionAudioModel;
  final List<AudioModel> audioModels;
  final List<CollectionAudioModel> listCollectionModels;
  final List ids;
  final AudioModel? audioModel;

  CreateCollectionState copyWith({
    String? id,
    String? titleOfCollection,
    String? image,
    String? descriptionOfAudio,
    String? createTime,
    int? allTimeAudioCollection,
    List? idAudioModels,
    CollectionAudioModel? collectionAudioModel,
    List<AudioModel>? audioModels,
    List<CollectionAudioModel>? listCollectionModels,
    List? ids,
    AudioModel? audioModel,
  }) {
    return CreateCollectionState(
      audioModel: audioModel ?? this.audioModel,
      id: id ?? this.id,
      titleOfCollection: titleOfCollection ?? this.titleOfCollection,
      image: image ?? this.image,
      descriptionOfAudio: descriptionOfAudio ?? this.descriptionOfAudio,
      createTime: createTime ?? this.createTime,
      allTimeAudioCollection:
          allTimeAudioCollection ?? this.allTimeAudioCollection,
      idAudioModels: idAudioModels ?? this.idAudioModels,
      collectionAudioModel: collectionAudioModel ?? this.collectionAudioModel,
      audioModels: audioModels ?? this.audioModels,
      listCollectionModels: listCollectionModels ?? this.listCollectionModels,
      ids: ids ?? this.ids,
    );
  }
}
