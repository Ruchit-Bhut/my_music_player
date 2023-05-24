// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/play_screen.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ShowInternalMusic extends StatefulWidget {
  ShowInternalMusic({super.key, required this.searchingController});
  TextEditingController searchingController;

  @override
  State<ShowInternalMusic> createState() => _ShowInternalMusicState();
}

class _ShowInternalMusicState extends State<ShowInternalMusic> {
  @override
  void initState() {
    super.initState();
    context.read<BottomPlayProvider>().audioRepo.getAllSongs();
    context.read<FavSongProvider>().getLocal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = context.watch<BottomPlayProvider>().audioPlayer;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: context.read<BottomPlayProvider>().audioRepo.songList.length,
        itemBuilder: (context, index) {
          final song =
              context.read<BottomPlayProvider>().audioRepo.songList[index];

          context.read<BottomPlayProvider>().musicModel = MusicModel(
              id: song.id,
              songName: song.displayNameWOExt,
              artistName: song.artist ?? '<unknown>',
              image: song.album ?? '',
              uri: song.uri ?? '',
              duration: song.duration!,
              index: index);

          final musicModel = context.read<BottomPlayProvider>().musicModel;
          context.read<BottomPlayProvider>().songLists.add(musicModel);
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
                setState(() {
                  navToPlayMusic(context, audioPlayer, index);
                  context.read<BottomPlayProvider>().isTrue(true);
                });
                context.read<BottomPlayProvider>().bottomBar(musicModel);
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
