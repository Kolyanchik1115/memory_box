part of 'create_collection_bloc.dart';

@immutable
abstract class CreateCollectionEvent {
  @override
  List<Object> get props => [];
}

class CreateCollectionInitialEvent extends CreateCollectionEvent {}

class CreateCollectionSaveEvent extends CreateCollectionEvent {}

class CreateCollectionListEvent extends CreateCollectionEvent {}

class CreateCollectionAddAudioEvent extends CreateCollectionEvent {
  CreateCollectionAddAudioEvent({required this.id});

  final List<String>? id;
}

class CollectionInitialEvent extends CreateCollectionEvent {}

class CollectionTimeAllAudioEvent extends CreateCollectionEvent {
  CollectionTimeAllAudioEvent();
// final int collectionIndex;
}

class CollectionItemInteractionEvent extends CreateCollectionEvent {
  CollectionItemInteractionEvent({
    required this.collectionIndex,
  });

  final int collectionIndex;
}

class CreateCollectionNameEvent extends CreateCollectionEvent {
  CreateCollectionNameEvent({this.titleOfCollection, this.descriptionOfCollection, this.pathToImage});

  final String? titleOfCollection;
  final String? descriptionOfCollection;
  final String? pathToImage;
}

class CreateCollectionDescriptionEvent extends CreateCollectionEvent {
  CreateCollectionDescriptionEvent({this.descriptionOfCollection});

  final String? descriptionOfCollection;
}

class CreateCollectionUploadImageEvent extends CreateCollectionEvent {
  CreateCollectionUploadImageEvent({this.image});

  final String? image;
}
