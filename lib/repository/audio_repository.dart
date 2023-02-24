import 'package:on_audio_query/on_audio_query.dart';

class AudioRepository {
  factory AudioRepository() {
    return instance;
  }

  AudioRepository._internal();

  static final AudioRepository instance = AudioRepository._internal();

  final _onAudioQuery = OnAudioQuery();

  final SongSortType? _sortType = null;
  final _orderType = OrderType.ASC_OR_SMALLER;
  final _uriType = UriType.EXTERNAL;
  final _ignoreCase = true;
  final List<SongModel> songList = [];
  int? currentIndex;

  void getAllSongs() {
    _onAudioQuery
        .querySongs(
          sortType: _sortType,
          orderType: _orderType,
          uriType: _uriType,
          ignoreCase: _ignoreCase,
        )
        .then((value) => songList.addAll(value));
  }
}
