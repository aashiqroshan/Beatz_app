import 'dart:io';

import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/user/offline/song_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class FavOffline extends StatefulWidget {
  const FavOffline({super.key});

  @override
  State<FavOffline> createState() => _FavOfflineState();
}

class _FavOfflineState extends State<FavOffline> {
  final Refactor refactor = Refactor();
  late PlaylistProvider playlistProvider;
  late Box<String> favoriteBox;

  void gotoSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    playlistProvider.play();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ));
  }

  void toggleFav(String songId) {
    setState(() {
      if (favoriteBox.containsKey(songId)) {
        favoriteBox.delete(songId);
      } else {
        favoriteBox.put(songId, songId);
      }
    });
  }

  bool isfav(String songId) {
    return favoriteBox.containsKey(songId);
  }

  @override
  void initState() {
    favoriteBox = Hive.box<String>('favBox');
    Future.delayed(
      Duration.zero,
      () {
        playlistProvider =
            Provider.of<PlaylistProvider>(context, listen: false);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final songBox = Hive.box<Song>('Box');
    final favoriteBox = Hive.box<String>('favBox');

    return Scaffold(
      appBar: refactor.appbartitles('Favorite Songs'),
      body: ValueListenableBuilder(
        valueListenable: favoriteBox.listenable(),
        builder: (context, Box<String> box, _) {
          final favoriteSongIds = box.values.toList();
          final favoriteSongs = favoriteSongIds
              .map((id) => songBox.values.firstWhere(
                    (song) => song.songName == id,
                  ))
              .where((song) => song != null)
              .toList();

          if (favoriteSongs.isEmpty) {
            return const Center(
              child: Text('No favorite songs yet!'),
            );
          }

          return ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              final Song song = favoriteSongs[index];
              return refactor.offlineListview(
                  song: song,
                  index: index,
                  goto: gotoSong,
                  toggle: toggleFav,
                  isFav: isfav);
            },
          );
        },
      ),
    );
  }
}
