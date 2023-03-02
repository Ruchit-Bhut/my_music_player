import 'package:flutter/material.dart';
import 'package:my_music_player/model/song_model.dart';

class PlayProvider with ChangeNotifier {
  List<MusicModel> songLists = [];

  passSongData(MusicModel musicModel) {
    songLists.add(musicModel);
    notifyListeners();
  }
}
