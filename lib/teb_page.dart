import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_music_player/model/song_model.dart';
import 'package:my_music_player/provider/fav_song_provider.dart';
import 'package:my_music_player/tab/favorite_page.dart';
import 'package:my_music_player/tab/online_songs.dart';
import 'package:my_music_player/tab/show_internal_music.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ShowTab extends StatefulWidget {
  const ShowTab({super.key});

  @override
  State<ShowTab> createState() => _ShowTabState();
}

class _ShowTabState extends State<ShowTab> {
  @override
  void initState() {
    super.initState();
    requestPermission();
    _searchingController.addListener(() {
      filterSongs();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<MusicModel> songFiltered = [];
  final TextEditingController _searchingController = TextEditingController();

  filterSongs() {
    List<MusicModel> music = [];
    music.addAll(context.read<FavSongProvider>().songdata);
    if(_searchingController.text.isNotEmpty){
      music.retainWhere((context){
        String searchTerm = _searchingController.text.toLowerCase();
        String musicName = context.songName.toLowerCase();
        return musicName.contains(searchTerm);
      });
      setState(() {
        songFiltered = music;
      });
    }
  }

  final OnAudioQuery audioQuery = OnAudioQuery();

  Future<void> requestPermission() async {
    if (!kIsWeb) {
      final permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      setState(() {});
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
                        setState(_searchingController.clear);
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
              const TabBar(
                indicatorWeight: 4,
                indicatorColor: Color(0xff0e2746),
                tabs: [
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
                  children: [
                    ShowInternalMusic(
                        searchingController: _searchingController),
                    const FavoriteSongs(),
                    const OnlineSongs(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
