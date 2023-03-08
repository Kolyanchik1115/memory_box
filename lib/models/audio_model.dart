class AudioModel {
  String id;
  String path;
  String durationOfAudio;
  String titleOfAudio;
  bool removedStatus;
  String timeOfAudio;
  String deleteTime;
  int recordDurationSeconds;

  AudioModel({
    required this.id,
    required this.path,
    required this.durationOfAudio,
    required this.titleOfAudio,
    required this.removedStatus,
    required this.timeOfAudio,
    required this.deleteTime,
    required this.recordDurationSeconds,
  });

  factory AudioModel.fromJson(Map<String, dynamic> json) {
    return AudioModel(
      recordDurationSeconds: json['recordDurationSeconds'],
      id: json['id'] as String,
      path: json['path'] as String,
      durationOfAudio: json['durationOfAudio'] as String,
      removedStatus: json['removedStatus'] as bool,
      titleOfAudio: json['titleOfAudio'] as String,
      timeOfAudio: json['timeOfAudio'] as String,
      deleteTime: json['deleteTime'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'durationOfAudio': durationOfAudio,
      'removedStatus': removedStatus,
      'titleOfAudio': titleOfAudio,
      'timeOfAudio': timeOfAudio,
      'deleteTime': deleteTime,
      'recordDurationSeconds': recordDurationSeconds,
    };
  }
}
