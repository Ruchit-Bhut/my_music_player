import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/repository/audio_repository.dart';

class Player {
  static final Player instance = Player._internal();
  Player._internal();

  final _audioPlayer = AudioPlayer();
  final songList = AudioRepository.instance.songList;

  factory Player() {
    return instance;
  }

  Future<void> playSong(String? uri) async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(uri!),
        ),
      );
      await _audioPlayer.play();
    } on Exception {
      stdout.write('Error parsing song');
    }
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }
}
