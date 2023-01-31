

class MusicModel {
  MusicModel({
     required this.id,
     required this.songName,
     required this.artistName,
    required this.image,
    required this.uri
  });

  int id;
  String songName;
  String artistName;
  String image;
  String uri;

  factory MusicModel.fromMap(Map<String, dynamic> json) => MusicModel(
    id: json['id'],
    songName: json['songName'],
    artistName: json['artistName'],
    image: json['image'],
    uri: json['uri'],
  );

  static Map<String, dynamic> toMap(MusicModel musicModel) => {
    'id': musicModel.id,
    'songName': musicModel.songName,
    'artistName': musicModel.artistName,
    'image': musicModel.image,
    'uri':musicModel.uri,
  };
}
