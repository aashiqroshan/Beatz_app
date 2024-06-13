import 'package:beatz_musicplayer/components/continue_playing.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/favService.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final Refactor refactor = Refactor();
  final FavoriteService _favoriteService = FavoriteService();
  List<String> _favSongIds = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteSongs();
  }

  void fetchFavoriteSongs() async {
    List<Map<String, dynamic>> favsongs =
        await _favoriteService.fetchFavSongs();
    setState(() {
      _favSongIds = favsongs.map((song) => song['id'] as String).toList();
    });
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    if (_favSongIds.contains(song['id'])) {
      await _favoriteService.removeFromFav(song['id']);
    } else {
      await _favoriteService.addTofav(song);
    }
    fetchFavoriteSongs();
  }

  void gotoSong(BuildContext context, List<Map<String, dynamic>> playlist,
      int songIndex) {
    final firebasePlaylistProvider =
        Provider.of<FirebasePlaylistProvider>(context, listen: false);
    firebasePlaylistProvider.setPlaylist(playlist, songIndex);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OnlineSongPage(playlist: playlist, songIndex: songIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song List'),
      ),
      body: Consumer<FirebasePlaylistProvider>(
        builder: (context, firebasePlaylistProvider, child) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Songs')
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

                    List<Map<String, dynamic>> playlist = snapshot.data!.docs
                        .map((doc) => {'id': doc.id, ...doc.data()})
                        .toList();

                    return refactor.likeListview(
                        items: playlist,
                        onTapf: gotoSong,
                        ontapt: toggleFavorite,
                        favSongid: _favSongIds);
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
                        firebasePlaylistProvider.currentSongIndex!]['imageUrl'],
                    onPlayPause: firebasePlaylistProvider.pauseOrResume,
                    onNext: firebasePlaylistProvider.playNextSong,
                    isPlaying: firebasePlaylistProvider.isPlaying)
            ],
          );
        },
      ),
    );
  }
}
