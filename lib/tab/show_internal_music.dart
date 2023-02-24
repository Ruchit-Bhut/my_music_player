// ignore_for_file: public_member_api_docs, must_be_immutable

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/play_screen.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:my_music_player/repository/audio_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ShowInternalMusic extends StatefulWidget {
  ShowInternalMusic({super.key, required this.searchingController});
  TextEditingController searchingController;

  @override
  State<ShowInternalMusic> createState() => _ShowInternalMusicState();
}

class _ShowInternalMusicState extends State<ShowInternalMusic> {
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    AudioRepository.instance.getAllSongs();
    context.read<FavSongProvider>().getLocal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: AudioRepository.instance.songList.length,
        itemBuilder: (context, index) {
          final song = AudioRepository.instance.songList[index];
          MusicModel musicModel = MusicModel(
            id: song.id,
            songName: song.displayNameWOExt,
            artistName: song.artist ?? '<unknown>',
            image: song.album ?? '',
            uri: song.uri ?? '',
            duration: song.duration!,
          );
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
                navToPlayMusic(context,_audioPlayer,index);

              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: QueryArtworkWidget(
                  id: int.parse(musicModel.id.toString()),
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
                musicModel.songName.toString(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              subtitle: Text(
                musicModel.artistName,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  if (context.read<FavSongProvider>().isFav(musicModel)) {
                    context.read<FavSongProvider>().remFav(musicModel);
                  } else {
                    context.read<FavSongProvider>().addToFav(musicModel);
                  }
                },
                child: context.watch<FavSongProvider>().isFav(
                          musicModel,
                        )
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
      ),
    );
  }
}
