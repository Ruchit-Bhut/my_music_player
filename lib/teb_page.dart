import 'package:flutter/material.dart';
import 'package:my_music_player/bottom_play_screen.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/provider/bottom_play_provider.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:my_music_player/tab/favorite_page.dart';
import 'package:my_music_player/tab/online_songs.dart';
import 'package:my_music_player/tab/show_internal_music.dart';
import 'package:provider/provider.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();

    setState(() {
      const BottomPlay();
    });
    tabController = TabController(length: 3, vsync: this);
    if (tabController!.index == 0) {
      searchingController.addListener(() {
        filterSongs();
      });
    }
  }

  List<MusicModel> songFiltered = [];
  final TextEditingController searchingController = TextEditingController();

  filterSongs() {
    List<MusicModel> music = [];
    music.addAll(context.read<FavSongProvider>().songdata);
    if (searchingController.text.isNotEmpty) {
      music.retainWhere((context) {
        String searchTerm = searchingController.text.toLowerCase();
        String musicName = context.songName.toLowerCase();
        return musicName.contains(searchTerm);
      });
      setState(() {
        songFiltered = music;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: DecoratedBox(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 50),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    fillColor: Colors.black12,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search Song ',
                    hintStyle: const TextStyle(
                      color: Colors.white60,
                      fontSize: 18,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(15),
                      width: 18,
                      child: Image.asset('assets/icons/search.png'),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(searchingController.clear);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: tabController,
                indicatorWeight: 4,
                indicatorColor: const Color(0xff0e2746),
                tabs: const [
                  Tab(
                    child: Image(
                      image: AssetImage(
                        'assets/icons/music-folder.png',
                      ),
                      height: 30,
                    ),
                  ),
                  Tab(
                    child: Image(
                      image: AssetImage(
                        'assets/icons/favorite-folder.png',
                      ),
                      height: 30,
                    ),
                  ),
                  Tab(
                    child: Image(
                      image: AssetImage(
                        'assets/icons/sound-cloud.png',
                      ),
                      height: 30,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ShowInternalMusic(searchingController: searchingController),
                    const FavoriteSongs(),
                    const OnlineSongs(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: context.watch<BottomPlayProvider>().isCheckPlay == true
              ? const BottomPlay()
              : const SizedBox(),
        ),
      ),
    );
  }
}
