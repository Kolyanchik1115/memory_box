class CollectionAudioModel {
  final String id;
  final String createTime;
  final String titleOfCollection;
  final String pathToImage;
  final int allTimeAudioCollection;
  final List idAudioModels;
  final String descriptionOfAudio;
  const CollectionAudioModel({
    required this.id,
    required this.createTime,
    required this.titleOfCollection,
    required this.allTimeAudioCollection,
    required this.idAudioModels,
    required this.pathToImage,
    required this.descriptionOfAudio,
  });

  factory CollectionAudioModel.fromJson(Map<String, dynamic> json) {
    return CollectionAudioModel(
      id: json['id'],
      createTime: json['createTime'],
      titleOfCollection: json['titleOfCollection'],
      allTimeAudioCollection: json['allTimeAudioCollection'],
      idAudioModels: json['idAudioModels'],
      pathToImage: json['pathToImage'],
      descriptionOfAudio: json['descriptionOfAudio'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'createTime': createTime,
      'titleOfCollection': titleOfCollection,
      'allTimeAudioCollection': allTimeAudioCollection,
      'idAudioModels': idAudioModels,
      'pathToImage': pathToImage,
      'descriptionOfAudio': descriptionOfAudio,
    };
  }
}
