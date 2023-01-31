import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_music_player/tab/favorite_page.dart';
import 'package:my_music_player/tab/online_songs.dart';
import 'package:my_music_player/tab/show_internal_music.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ShowTab extends StatefulWidget {
  const ShowTab({super.key});

  @override
  State<ShowTab> createState() => _ShowTabState();
}

class _ShowTabState extends State<ShowTab> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final TextEditingController _searchingController = TextEditingController();

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
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    super.dispose();
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
                Color(0xff4c6f8d),
                Color(0xff3a5c78),
                Color(0xff2d4a68),
                Color(0xff1b3654),
                Color(0xff0e2746),
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
                    fillColor:
                        const Color(0xff30164e),
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
                    ShowInternalMusic(searchingController:_searchingController),
                    FavoriteSongs(),
                    OnlineSongs(),
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
