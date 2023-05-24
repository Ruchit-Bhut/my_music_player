import 'dart:developer';

import 'package:on_audio_query/on_audio_query.dart';

class MusicModel {
  MusicModel({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.image,
    required this.uri,
    required this.duration,
    required this.index,
  });

  int id;
  String songName;
  String artistName;
  String image;
  String uri;
  int duration;
  int index;

  factory MusicModel.fromMap(Map<String, dynamic> json) => MusicModel(
        id: json['id'],
        songName: json['songName'],
        artistName: json['artistName'],
        image: json['image'],
        uri: json['uri'],
        duration: json['duration'],
        index: json['index'],
      );

  static Map<String, dynamic> toMap(MusicModel musicModel) => {
        'id': musicModel.id,
        'songName': musicModel.songName,
        'artistName': musicModel.artistName,
        'image': musicModel.image,
        'uri': musicModel.uri,
        'duration': musicModel.duration,
        "index": musicModel.index,
      };
}

MusicModel songToMusic(SongModel song, int index) {
  log(song.data);
  return MusicModel(
      id: song.id,
      songName: song.displayNameWOExt,
      artistName: song.artist ?? '<unknown>',
      image: song.album ?? '',
      uri: song.uri ?? '',
      duration: song.duration!,
      index: index);
}
