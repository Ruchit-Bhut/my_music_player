import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/repository/audio_repository.dart';

class PlayProvider with ChangeNotifier {

  final audioPlayer = AudioPlayer();
  MusicModel? musicModel;

  List<MusicModel> songLists = [];

  bool isShow = false;
  passSongData(MusicModel musicModel) {
    songLists.add(musicModel);
    notifyListeners();
  }

  List<MusicModel> bottomPlay = [];
  void bottomBar(MusicModel musicModel){
    bottomPlay.clear();
    bottomPlay.add(musicModel);
    notifyListeners();
  }

  List<MusicModel>selectedSong = [];
  void selectSong(MusicModel musicModel){
    selectedSong.clear();
    selectedSong.add(musicModel);
  }
}
