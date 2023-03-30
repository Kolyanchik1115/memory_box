part of 'collection_bloc.dart';

class CollectionState {
  const CollectionState({
    this.collectionAudioModels = const [],
    this.counterAudio = 0,
    this.collectionAudioModel = const CollectionAudioModel(
      id: '',
      createTime: '',
      titleOfCollection: '',
      allTimeAudioCollection: 0,
      descriptionOfAudio: '',
      idAudioModels: [],
      pathToImage: '',
    ),
    this.audioIds = const [],
    this.titleOfCollection = '',
    this.descriptionOfCollection = '',
    this.pathToImage = '',
    this.allTimeAudioCollection = 0,
    this.createTime = '',
    this.uuid = '',
    this.collectionAddId = '',
    this.audioAddId = '',
  });

  final List<CollectionAudioModel> collectionAudioModels;
  final int counterAudio;
  final CollectionAudioModel collectionAudioModel;
  final List audioIds;
  final String titleOfCollection;
  final String descriptionOfCollection;
  final String pathToImage;
  final int allTimeAudioCollection;
  final String createTime;
  final String uuid;
  final String collectionAddId;
  final String audioAddId;

  CollectionState copyWith({
    String? collectionAddId,
    String? audioAddId,
    String? uuid,
    List<CollectionAudioModel>? collectionAudioModels,
    int? counterAudio,
    CollectionAudioModel? collectionAudioModel,
    String? titleOfCollection,
    String? descriptionOfCollection,
    String? pathToImage,
    List? audioIds,
    int? allTimeAudioCollection,
    String? createTime,
  }) {
    return CollectionState(
      collectionAddId: collectionAddId ?? this.collectionAddId,
      audioAddId: audioAddId ?? this.audioAddId,
      uuid: uuid ?? this.uuid,
      collectionAudioModels:
          collectionAudioModels ?? this.collectionAudioModels,
      collectionAudioModel: collectionAudioModel ?? this.collectionAudioModel,
      counterAudio: counterAudio ?? this.counterAudio,
      titleOfCollection: titleOfCollection ?? this.titleOfCollection,
      descriptionOfCollection:
          descriptionOfCollection ?? this.descriptionOfCollection,
      pathToImage: pathToImage ?? this.pathToImage,
      audioIds: audioIds ?? this.audioIds,
      allTimeAudioCollection:
          allTimeAudioCollection ?? this.allTimeAudioCollection,
      createTime: createTime ?? this.createTime,
    );
  }
}
