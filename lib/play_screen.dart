// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:just_audio/just_audio.dart';

class PlayMusicScreen extends StatefulWidget {
  const PlayMusicScreen({
    super.key,
    required this.musicModel,
    required this.audioPlayer,
  });

  final MusicModel musicModel;
  final AudioPlayer audioPlayer;

  @override
  State<PlayMusicScreen> createState() => _PlayMusicScreenState();
}

class _PlayMusicScreenState extends State<PlayMusicScreen> {
  Duration _position = const Duration();
  Duration _duration = const Duration();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    SongDuration();
  }

  void SongDuration() {
    try {
      widget.audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.musicModel.uri),
        ),
      );
      widget.audioPlayer.play();
      _isPlaying = true;
    } on Exception {
      stdout.write('Error parsing song');
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });

    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
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
        backgroundColor: const Color(0xff4c6f8d),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.chevron_left,
            size: 35,
          ),
        ),
        title: TextScroll(
          widget.musicModel.songName.toString(),
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
                Color(0xff4c6f8d),
                Color(0xff3a5c78),
                Color(0xff2d4a68),
                Color(0xff1b3654),
                Color(0xff0e2746),
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
                  id: int.parse(widget.musicModel.id.toString()),
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
                        widget.musicModel.songName.toString(),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (context
                                  .read<FavSongProvider>()
                                  .isFav(widget.musicModel)) {
                                context
                                    .read<FavSongProvider>()
                                    .remFav(widget.musicModel);
                              } else {
                                context
                                    .read<FavSongProvider>()
                                    .addToFav(widget.musicModel);
                              }
                            },
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: context
                                      .watch<FavSongProvider>()
                                      .isFav(widget.musicModel)
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
                        widget.musicModel.artistName.toString() == '<unknown>'
                            ? 'Unknown Artist'
                            : widget.musicModel.artistName.toString(),
                        maxLines: 1,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 20),
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
                          onPressed: () {},
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
                              if (_isPlaying) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                              _isPlaying = !_isPlaying;
                            });
                          },
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          iconSize: 45,
                          color: Colors.white,
                          onPressed: () {},
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
