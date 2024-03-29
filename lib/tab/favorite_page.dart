import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/play_screen.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class FavoriteSongs extends StatefulWidget {
  const FavoriteSongs({
    super.key,
  });

  @override
  State<FavoriteSongs> createState() => _FavoriteSongsState();
}

class _FavoriteSongsState extends State<FavoriteSongs> {
  final AudioPlayer _audioPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();
    context.read<FavSongProvider>().getLocal();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: context.watch<FavSongProvider>().songdata.isNotEmpty
          ? ListView.builder(
              itemCount: context.watch<FavSongProvider>().songdata.length,
              itemBuilder: (context, index) {
                MusicModel data =
                    context.watch<FavSongProvider>().songdata[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black26,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  child: ListTile(
                    onTap: () {
                      context.read<FavSongProvider>().isFav(data);

                      navToPlayMusic(context, _audioPlayer, data.index);
                      context.read<BottomPlayProvider>().bottomBar(data);
                      context.read<BottomPlayProvider>().isTrue(true);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: QueryArtworkWidget(
                        id: int.parse(data.id.toString()),
                        type: ArtworkType.AUDIO,
                        keepOldArtwork: true,
                        artworkHeight: 50,
                        artworkWidth: 50,
                        nullArtworkWidget: Image.asset(
                          'assets/icons/music.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    title: Text(
                      data.songName.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      data.artistName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        if (context.read<FavSongProvider>().isFav(
                              data,
                            )) {
                          context.read<FavSongProvider>().remFav(data);
                        } else {
                          context.read<FavSongProvider>().addToFav(data);
                        }
                      },
                      child: context.watch<FavSongProvider>().isFav(data)
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
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                "No Like Songs Found",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
    );
  }
}
