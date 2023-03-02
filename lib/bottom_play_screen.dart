import 'package:flutter/material.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class BottomPlay extends StatefulWidget {
  const BottomPlay({Key? key}) : super(key: key);

  @override
  State<BottomPlay> createState() => _BottomPlayState();
}

class _BottomPlayState extends State<BottomPlay> {
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child:
                //  QueryArtworkWidget(
                //   id: int.parse(musicModel.id.toString()),
                //   type: ArtworkType.AUDIO,
                //   keepOldArtwork: true,
                //   artworkHeight: 70,
                //   artworkWidth: 70,
                //   nullArtworkWidget: Image.asset(
                //     'assets/icons/music.png',
                //     height: 70,
                //     width: 70,
                //   ),
                // ),

                Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          SizedBox(
            height: 30,
            width: 150,
            child: Column(
              children: [
                if (context.read<PlayProvider>().songLists.isNotEmpty)
                  TextScroll(
                    context.read<PlayProvider>().songLists.first.songName,
                    velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
                    pauseBetween: const Duration(milliseconds: 1000),
                    style: const TextStyle(fontSize: 22),
                  ),
                // Text(
                //   context.read<PlayProvider>().songLists.first.songName,
                //   style: TextStyle(
                //       color: Colors.white.withOpacity(0.70), fontSize: 20),
                // ),
                Text(
                  'Artist name',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.40), fontSize: 20),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   width: 5,
          // ),
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
