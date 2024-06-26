import 'package:beatz_musicplayer/components/continue_playing.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/favService.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistPage extends StatefulWidget {
  const ArtistPage({super.key, required this.artist});
  final String artist;

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final FavoriteService favoriteService = FavoriteService();
  final Refactor refactor = Refactor();
  FirebasePlaylistProvider firebasePlaylistProvider =
      FirebasePlaylistProvider();
  List<String> _favSongIds = [];

  void fetchFavSongs() async {
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
        appBar: refactor.appbartitles(widget.artist),
        body: Consumer<FirebasePlaylistProvider>(
          builder: (context, firebasePlaylistProvider, child) {
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Songs')
                        .where('artist', isEqualTo: widget.artist)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error} '),
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
