import 'package:beatz_musicplayer/components/continue_playing.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/favService.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key, required this.language});
  final String language;

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final Refactor refactor = Refactor();
  FirebasePlaylistProvider firebasePlaylistProvider =
      FirebasePlaylistProvider();
  final FavoriteService favoriteService = FavoriteService();
  List<String> _favSongId = [];

  void fetchFavSongs() async {
    List<Map<String, dynamic>> favsong = await favoriteService.fetchFavSongs();
    setState(() {
      _favSongId = favsong.map((song) => song['id'] as String).toList();
    });
  }

  Future<void> toggleFav(Map<String, dynamic> song) async {
    if (_favSongId.contains(song['id'])) {
      await favoriteService.removeFromFav(song['id']);
    } else {
      await favoriteService.addTofav(song);
    }
    fetchFavSongs();
  }

  @override
  void initState() {
    super.initState();
    fetchFavSongs();
  }

  void gotoSong(BuildContext context, List<Map<String, dynamic>> playlist,
      int songIndex) async {
    final firebaseplay =
        Provider.of<FirebasePlaylistProvider>(context, listen: false);
    firebaseplay.setPlaylist(playlist, songIndex);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OnlineSongPage(playlist: playlist, songIndex: songIndex),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.language),
        ),
        body: Consumer<FirebasePlaylistProvider>(
          builder: (context, firebasePlaylistProvider, child) {
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Songs')
                        .where('language', isEqualTo: widget.language)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No songs found in this language'),
                        );
                      }

                      var songs = snapshot.data!.docs.map(
                        (doc) {
                          var song = doc.data();
                          song['id'] = doc.id;
                          return song;
                        },
                      ).toList();
                      return refactor.likeListview(
                          items: songs,
                          onTapf: gotoSong,
                          ontapt: toggleFav,
                          favSongid: _favSongId);
                    },
                  ),
                ),
                if (firebasePlaylistProvider.currentSongIndex != null)
                  ContinuePlaying(
                      songTitle: firebasePlaylistProvider.playlist[
                          firebasePlaylistProvider.currentSongIndex!]['title'],
                      artist: firebasePlaylistProvider.playlist[
                          firebasePlaylistProvider.currentSongIndex!]['artist'],
                      imageUrl: firebasePlaylistProvider.playlist[
                              firebasePlaylistProvider.currentSongIndex!]
                          ['imageUrl'],
                      onPlayPause: firebasePlaylistProvider.pauseOrResume,
                      onNext: firebasePlaylistProvider.playNextSong,
                      isPlaying: firebasePlaylistProvider.isPlaying)
              ],
            );
          },
        ));
  }
}
