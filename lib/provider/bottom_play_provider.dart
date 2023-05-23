import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/repository/audio_repository.dart';

class BottomPlayProvider with ChangeNotifier {
  final audioRepo = AudioRepository.instance;

  final audioPlayer = AudioPlayer();
  late MusicModel musicModel;

  void play() async {
    await audioPlayer.play();
    notifyListeners();
  }

  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  void nextSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! + 1;

    musicModel = songToMusic(
        AudioRepository().songList[AudioRepository().currentIndex!],AudioRepository().currentIndex!);

    audioPlayer.seekToNext();
    bottomBar(musicModel);
    notifyListeners();
  }

  void previousSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! - 1;

    musicModel = songToMusic(
        AudioRepository().songList[AudioRepository().currentIndex!],AudioRepository().currentIndex!);

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

  bool isCheckPlay = false;

  void isTrue(bool value) {
    isCheckPlay = value;
    notifyListeners();
  }

  bool isPlaying = false;

  void isPlayOnChanged() {
    isPlaying = !isPlaying;
    notifyListeners();
  }
}
