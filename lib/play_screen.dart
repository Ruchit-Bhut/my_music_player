// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:my_music_player/repository/audio_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:just_audio/just_audio.dart';

navToPlayMusic(BuildContext context, AudioPlayer audioPlayer, int index) {
  AudioRepository().currentIndex = index;
  Navigator.push(
    context,
    MaterialPageRoute<dynamic>(
      builder: (context) => PlayMusicScreen(
        audioPlayer: audioPlayer,
      ),
    ),
  );
}

class PlayMusicScreen extends StatefulWidget {
  const PlayMusicScreen({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

  @override
  State<PlayMusicScreen> createState() => _PlayMusicScreenState();
}

class _PlayMusicScreenState extends State<PlayMusicScreen> {
  Duration _position = const Duration();
  Duration _duration = const Duration();
  bool _isPlaying = false;
  MusicModel musicModel =
      songToMusic(AudioRepository().songList[AudioRepository().currentIndex!]);

  @override
  void initState() {
    super.initState();
    SongDuration();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void SongDuration() {
    if (widget.audioPlayer.audioSource == null) {
      try {
        widget.audioPlayer.setAudioSource(ConcatenatingAudioSource(
            children: AudioRepository.instance.songList
                .map((e) => AudioSource.uri(
                      Uri.parse(e.uri!),
                    ))
                .toList()));
      } on Exception {
        log("Error in loading list");
      }
    }
    context.read<PlayProvider>().musicModel = musicModel;
    widget.audioPlayer.seek(Duration.zero,
        index: AudioRepository.instance.songList
            .indexWhere((element) => element.id == musicModel.id));
    widget.audioPlayer.play();
    setState(() {});
    widget.audioPlayer.durationStream.listen((d) {
      if (mounted) {
        setState(() {
          _duration = d ?? const Duration(seconds: 0);
        });
      }
    });

    widget.audioPlayer.positionStream.listen((p) {
      if (mounted) {
        setState(() {
          _position = p;
        });
      }
    });
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }

  void nextSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! + 1;

    musicModel = songToMusic(
        AudioRepository().songList[AudioRepository().currentIndex!]);

    setState(() {
      widget.audioPlayer.seekToNext();
    });
  }

  void previousSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! - 1;

    musicModel = songToMusic(
        AudioRepository().songList[AudioRepository().currentIndex!]);

    setState(() {
      widget.audioPlayer.seekToPrevious();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        actions: const [
          SizedBox(
            width: 6,
            child: Image(
              image: AssetImage('assets/icons/ThreeDot.png'),
            ),
          ),
          SizedBox(
            width: 20,
          )
        ],
        backgroundColor: const Color(0xff8a8390),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            size: 35,
          ),
        ),
        title: TextScroll(
          musicModel.songName.toString(),
          velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
          pauseBetween: const Duration(milliseconds: 1000),
          style: const TextStyle(fontSize: 22),
        ),
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8a8390),
                Color(0xff75697b),
                Color(0xff5c4b63),
                Color(0xff4b3753),
                Color(0xff382040),
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                QueryArtworkWidget(
                  id: int.parse(musicModel.id.toString()),
                  type: ArtworkType.AUDIO,
                  keepOldArtwork: true,
                  artworkHeight: 350,
                  artworkWidth: 350,
                  nullArtworkWidget: Image.asset(
                    'assets/icons/music.png',
                    height: 350,
                    width: 350,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        musicModel.songName.toString(),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(8, 8),
                              blurRadius: 10,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (context
                                  .read<FavSongProvider>()
                                  .isFav(musicModel)) {
                                context
                                    .read<FavSongProvider>()
                                    .remFav(musicModel);
                              } else {
                                context
                                    .read<FavSongProvider>()
                                    .addToFav(musicModel);
                              }
                            },
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: context
                                      .watch<FavSongProvider>()
                                      .isFav(musicModel)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        musicModel.artistName.toString() == '<unknown>'
                            ? 'Unknown Artist'
                            : musicModel.artistName.toString(),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(5, 5),
                              blurRadius: 5,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            _position.toString().split(".")[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.white12,
                              value: _position.inSeconds.toDouble(),
                              min: const Duration(microseconds: 0)
                                  .inSeconds
                                  .toDouble(),
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  changeToSeconds(value.toInt());
                                  value = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            _duration.toString().split(".")[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 45,
                          color: Colors.white,
                          onPressed: previousSong,
                          icon: const Icon(Icons.skip_previous_rounded),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          iconSize: 70,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                              if (_isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                            });
                          },
                          icon: Icon(
                            _isPlaying
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          iconSize: 45,
                          color: Colors.white,
                          onPressed: nextSong,
                          icon: const Icon(Icons.skip_next_rounded),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
