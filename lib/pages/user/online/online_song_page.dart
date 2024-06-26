import 'dart:math';

import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/favService.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlineSongPage extends StatefulWidget {
  const OnlineSongPage(
      {super.key, required this.playlist, required this.songIndex});
  final List<Map<String, dynamic>> playlist;
  final int songIndex;

  @override
  State<OnlineSongPage> createState() => _OnlineSongPageState();
}

class _OnlineSongPageState extends State<OnlineSongPage> {
  final Refactor refactor = Refactor();
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  final FavoriteService favoriteService = FavoriteService();
  List<String> _favSongIds = [];
  bool _isShuffle = false;
  bool _isRepeat = false;
  int currentSongIndex = 0;

  void fetchFavSong() async {
    List<Map<String, dynamic>> favsongs = await favoriteService.fetchFavSongs();
    setState(() {
      _favSongIds = favsongs.map((song) => song['id'] as String).toList();
    });
  }

  Future<void> toggleFav(Map<String, dynamic> song) async {
    if (_favSongIds.contains(song['id'])) {
      await favoriteService.removeFromFav(song['id']);
    } else {
      await favoriteService.addTofav(song);
    }
    setState(() {
      fetchFavSong();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFavSong();
    currentSongIndex = widget.songIndex;
  }

  void toggleshuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  void toggleRepeat() {
    setState(() {
      _isRepeat = !_isRepeat;
    });
  }

  @override
  void didUpdateWidget(covariant OnlineSongPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.songIndex != widget.songIndex) {
      setState(() {
        currentSongIndex = widget.songIndex;
      });
    }
  }

  void playNext(FirebasePlaylistProvider value) {
    int nextIndex;
    if (_isShuffle) {
      nextIndex = Random().nextInt(widget.playlist.length);
    } else {
      nextIndex = (widget.songIndex + 1) % widget.playlist.length;
    }
    value.playSong(widget.playlist[nextIndex], nextIndex);
    setState(() {
      currentSongIndex = nextIndex;
    });
  }

  void playPrevious(FirebasePlaylistProvider value) {
    int previousIndex;
    if (_isShuffle) {
      previousIndex = Random().nextInt(widget.playlist.length);
    } else {
      if (widget.songIndex > 0) {
        previousIndex = widget.songIndex - 1;
      } else {
        previousIndex = widget.playlist.length - 1;
      }
    }
    value.playSong(widget.playlist[previousIndex], previousIndex);
    setState(() {
      currentSongIndex = previousIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebasePlaylistProvider>(
      builder: (context, value, child) {
        final currentSong = widget.playlist[widget.songIndex];
        var isFav = _favSongIds.contains(currentSong['id']);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    refactor.boldfontstyle('Online PLayer'),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3))
                      ]),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: refactor.imagecropme(currentSong['imageUrl'])),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            currentSong['title'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(currentSong['artist']),
                        ],
                      ),
                      IconButton(
                          onPressed: () async {
                            await toggleFav(currentSong);
                          },
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null,
                          ))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      refactor.boldfonttxt(formatTime(value.currentDuration)),
                      IconButton(
                          onPressed: toggleshuffle,
                          icon: Icon(
                            Icons.shuffle,
                            color: _isShuffle ? Colors.red : Colors.black,
                          )),
                      IconButton(
                          onPressed: toggleRepeat,
                          icon: Icon(
                            Icons.repeat,
                            color: _isRepeat ? Colors.red : Colors.black,
                          )),
                      refactor.boldfonttxt(formatTime(value.totalDuration))
                    ],
                  ),
                ),
                SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5)),
                    child: Slider(
                      min: 0,
                      max: value.totalDuration.inSeconds.toDouble(),
                      value: value.currentDuration.inSeconds.toDouble(),
                      onChanged: (double newvalue) {},
                      onChangeEnd: (double newvalue) {
                        value.seek(Duration(seconds: newvalue.toInt()));
                      },
                    )),
                Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () => playPrevious(value),
                      child: const Icon(
                        Icons.skip_previous,
                        size: 50,
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: value.pauseOrResume,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        height: 80,
                        width: 80,
                        child: Icon(
                          value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () => playNext(value),
                      child: const Icon(
                        Icons.skip_next,
                        size: 50,
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
