import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_music_player/play_screen.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class BottomPlay extends StatefulWidget {
  const BottomPlay({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomPlay> createState() => _BottomPlayState();
}

class _BottomPlayState extends State<BottomPlay> {
  // bool _isPlayingBottom = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navToPlayMusic(context, context.read<BottomPlayProvider>().audioPlayer,
            context.read<BottomPlayProvider>().audioPlayer.currentIndex!);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CupertinoButton(
            onPressed: () {
              setState(() {
                context.read<BottomPlayProvider>().audioPlayer.pause();
                context.read<BottomPlayProvider>().isTrue(false);
              });
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff75697b),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                if (context.read<BottomPlayProvider>().bottomPlay.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: QueryArtworkWidget(
                      id: context
                          .watch<BottomPlayProvider>()
                          .bottomPlay
                          .first
                          .id,
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
                      if (context
                          .watch<BottomPlayProvider>()
                          .musicModel
                          .toString()
                          .isNotEmpty)
                        TextScroll(
                          "${context.watch<BottomPlayProvider>().audioRepo.songList.where((element) => context.watch<BottomPlayProvider>().bottomPlay.first.id == element.id).map((e) => e.displayName.toString())}",
                          velocity:
                              const Velocity(pixelsPerSecond: Offset(50, 0)),
                          pauseBetween: const Duration(milliseconds: 1000),
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        ),
                      if (context
                          .read<BottomPlayProvider>()
                          .bottomPlay
                          .isNotEmpty)
                        Text(
                          context
                              .watch<BottomPlayProvider>()
                              .bottomPlay
                              .first
                              .artistName,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.60),
                              fontSize: 16),
                        ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<BottomPlayProvider>().previousSong();
                  },
                  child: const Icon(
                    Icons.skip_previous_outlined,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      context.read<BottomPlayProvider>().isPlayOnChanged();
                      if (context.read<BottomPlayProvider>().isPlaying) {
                        context.read<BottomPlayProvider>().audioPlayer.pause();
                      } else {
                        context.read<BottomPlayProvider>().audioPlayer.play();
                      }
                    });
                  },
                  child: Icon(
                    context.watch<BottomPlayProvider>().isPlaying
                        ? Icons.play_circle_outline_rounded
                        : Icons.pause_circle_outline_rounded,
                    color: Colors.white,
                    size: 70,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<BottomPlayProvider>().nextSong();
                  },
                  child: const Icon(
                    Icons.skip_next_outlined,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
