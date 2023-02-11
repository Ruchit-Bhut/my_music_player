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
        backgroundColor: const Color(0xff8a8390),
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
                          onPressed: () async {

                          },
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
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          iconSize: 45,
                          color: Colors.white,
                          onPressed: () async {

                          },
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






// next and previous song in app


// import 'package:audio_service/audio_service.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Music Player',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MainPage(),
//     );
//   }
// }
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   var _currentIndex = 0;
//   var _songs = [
//     'song1.mp3',
//     'song2.mp3',
//     'song3.mp3',
//     'song4.mp3',
//     'song5.mp3',
//   ];
//
//   void _playNextSong() {
//     setState(() {
//       _currentIndex = (_currentIndex + 1) % _songs.length;
//       AudioService.play(_songs[_currentIndex]);
//     });
//   }
//
//   void _playPreviousSong() {
//     setState(() {
//       _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
//       AudioService.play(_songs[_currentIndex]);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text("Now playing: ${_songs[_currentIndex]}"),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.skip_previous),
//                   onPressed: _playPreviousSong,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.play_arrow),
//                   onPressed: () => AudioService.play(_songs[_currentIndex]),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.skip_next),
//                   onPressed: _playNextSong,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
