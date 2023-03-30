part of 'collection_bloc.dart';

abstract class CollectionEvent {
  const CollectionEvent();
}

class CollectionGetCardInitial extends CollectionEvent {
  CollectionGetCardInitial({required this.collectionAudioModel});

  final CollectionAudioModel collectionAudioModel;
}
class InitCollectionCardEvent extends CollectionEvent{

}
class DeleteCollectionCardEvent extends CollectionEvent{

}
class AddAnyCollectionCardEvent extends CollectionEvent{

}
class ShareCollectionCardEvent extends CollectionEvent{

}

class ChangeImageCollectionCardEvent extends CollectionEvent {}

class ChangeTitleCollectionCardEvent extends CollectionEvent {
  ChangeTitleCollectionCardEvent({required this.titleOfCollection});

  final String titleOfCollection;
}

class ChangeDescriptionCollectionCardEvent extends CollectionEvent {
  ChangeDescriptionCollectionCardEvent({required this.descriptionOfCollection});

  final String descriptionOfCollection;
}

class SaveEditedCollectionCardEvent extends CollectionEvent {}

class GetIdAudioEvent extends CollectionEvent {
  GetIdAudioEvent( {required this.audioAddId, required this.audioInSeconds});
  final String? audioAddId;
  final int audioInSeconds;
}
class SelectCollection extends CollectionEvent{
  SelectCollection({required this.collectionAddId});
  final String? collectionAddId;
}

class AddToCollectionAudioEvent extends CollectionEvent{
}
class UpdateAudio extends CollectionEvent{

}

class DeleteAudioCollectionEvent extends CollectionEvent{
  DeleteAudioCollectionEvent({required this.uuidAudio});
String uuidAudio;
}