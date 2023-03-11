import 'package:flutter/material.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:my_music_player/repository/audio_repository.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class BottomPlay extends StatefulWidget {
  const BottomPlay({Key? key, }) : super(key: key);

  @override
  State<BottomPlay> createState() => _BottomPlayState();
}

class _BottomPlayState extends State<BottomPlay> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
      });
    });
  }



  void nextSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! + 1;

     context.watch<PlayProvider>().musicModel;

    setState(() {
      context.read<PlayProvider>().audioPlayer.seekToNext();
    });
  }

  void previousSong() {
    AudioRepository().currentIndex = AudioRepository().currentIndex! - 1;

    context.watch<PlayProvider>().musicModel;

    setState(() {
      context.read<PlayProvider>().audioPlayer.seekToPrevious();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff75697b),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          if (context.read<PlayProvider>().bottomPlay.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: QueryArtworkWidget(
                id: context.watch<PlayProvider>().bottomPlay.first.id,
                type: ArtworkType.AUDIO,
                keepOldArtwork: true,
                artworkHeight: 70,
                artworkWidth: 70,
                nullArtworkWidget: Image.asset(
                  'assets/icons/music.png',
                  height: 70,
                  width: 70,
                ),
              ),
            ),
          SizedBox(
            height: 60,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (context.read<PlayProvider>().bottomPlay.isNotEmpty)
                  TextScroll(
                    context.watch<PlayProvider>().bottomPlay.first.songName,
                    velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                    pauseBetween: const Duration(milliseconds: 1000),
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                if (context.read<PlayProvider>().bottomPlay.isNotEmpty)
                  Text(
                    context.watch<PlayProvider>().bottomPlay.first.artistName,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.60), fontSize: 16),
                  ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.skip_previous_outlined,
              color: Colors.white,
              size: 45,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.play_circle_outline_rounded,
              color: Colors.white,
              size: 70,
            ),
          ),
          InkWell(
            onTap: () {},
            child: const Icon(
              Icons.skip_next_outlined,
              color: Colors.white,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }
}
