import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/repository/audio_repository.dart';

class PlayProvider with ChangeNotifier {
  final allData = [];

  final audioRepo = AudioRepository.instance;

  final audioPlayer = AudioPlayer();
  late MusicModel musicModel;

  List<MusicModel> songLists = [];

  bool isShow = false;
  passSongData(MusicModel musicModels) {
    songLists.add(musicModels);
    notifyListeners();
  }

  List<MusicModel> bottomPlay = [];
  void bottomBar(MusicModel musicModels) {
    bottomPlay.clear();
    bottomPlay.add(musicModels);
    notifyListeners();
  }

  void nextSong(MusicModel musicModel) {
    bottomPlay.first.id = bottomPlay.first.id + 1;

    musicModel = bottomPlay.first.id as MusicModel;

    notifyListeners();

    // musicModel = songToMusic(
    //     AudioRepository().songList[AudioRepository().currentIndex!]);
  }

  // Future<bool> selectSong(MusicModel musicModels) async {
  //   return musicModel.id == musicModels.id;
  // }

  // void nextSong(MusicModel musicModel) {
  //   bottomPlay.first.id = bottomPlay.first.id + 1;
  //   notifyListeners();
  // }

  void previousSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! - 1;
  }
}
