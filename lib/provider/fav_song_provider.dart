import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavSongProvider with ChangeNotifier {
  List<int> fav = [];
  List<MusicModel> songdata = [];

  void addToFav(MusicModel songModel) {
    fav.add(songModel.id);
    songdata.add(songModel);
    setLocal();
    notifyListeners();
  }

  void remFav(MusicModel songModel) {
    fav.remove(songModel.id);
    songdata.removeWhere((e) => e.id == songModel.id);
    setLocal();
    notifyListeners();
  }

  bool isFav(MusicModel songModel) {
    return fav.contains(songModel.id);
  }

  Future<void> setLocal() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setStringList(
        'favoriteId', fav.map((e) => e.toString()).toList());
    final String jsonData = encode(songdata);
    pref.setString("favourite", jsonData);
    notifyListeners();
  }

  Future<void> getLocal() async {
    final pref = await SharedPreferences.getInstance();
    fav = pref.getStringList('favoriteId')!.map(int.parse).toList();
    final String? getJsonData = pref.getString("favourite");
    songdata = decode(getJsonData!);

    notifyListeners();
  }

  static String encode(List<MusicModel> songdata) => json.encode(songdata
      .map<Map<String, dynamic>>((musics) => MusicModel.toMap(musics))
      .toList());

  static List<MusicModel> decode(String musicModel) =>
      (json.decode(musicModel) as List<dynamic>)
          .map<MusicModel>((e) => MusicModel.fromMap(e))
          .toList();
}
