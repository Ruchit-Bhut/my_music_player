import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/repository/audio_repository.dart';

class BottomPlayProvider with ChangeNotifier {
  final audioRepo = AudioRepository.instance;

  final audioPlayer = AudioPlayer();
  late MusicModel musicModel;


  void nextSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! + 1;

    musicModel = songToMusic(
        AudioRepository().songList[AudioRepository().currentIndex!]);


     audioPlayer.seekToNext();
      bottomBar(musicModel);
      notifyListeners();

  }

  void previousSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! - 1;

    musicModel = songToMusic(
        AudioRepository().songList[AudioRepository().currentIndex!]);


      audioPlayer.seekToPrevious();
      bottomBar(musicModel);
notifyListeners();
  }

  List<MusicModel> songLists = [];
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



  // void nextSong(MusicModel musicModel) {
  //   bottomPlay.first.id = bottomPlay.first.id + 1;
  //   notifyListeners();
  // }

  // void previousSong() {
  //   AudioRepository().currentIndex = AudioRepository().currentIndex! - 1;
  // }
}
