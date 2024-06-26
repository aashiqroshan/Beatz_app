import 'package:beatz_musicplayer/components/continue_playing.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/favService.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavOnline extends StatefulWidget {
  const FavOnline({super.key});

  @override
  State<FavOnline> createState() => _FavOnlineState();
}

class _FavOnlineState extends State<FavOnline> {
  final FavoriteService _favoriteService = FavoriteService();
  List<Map<String, dynamic>> _favSong = [];
  final Refactor refactor = Refactor();

  @override
  void initState() {
    super.initState();
    fetchFavorite();
  }

  void fetchFavorite() async {
    try {
      List<Map<String, dynamic>> favSongs =
          await _favoriteService.fetchFavSongs();
      setState(() {
        _favSong = favSongs;
      });
    } catch (e) {
      debugPrint('Error fetching favorite songs: $e');
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> song) async {
    if (_favSong.any((favSong) => favSong['id'] == song['id'])) {
      await _favoriteService.removeFromFav(song['id']);
    } else {
      await _favoriteService.addTofav(song['id']);
    }
    fetchFavorite();
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: refactor.appbartitles('Favorite Songs'),
        body: Consumer<FirebasePlaylistProvider>(
          builder: (context, firebasePlaylistProvider, child) {
            return Column(
              children: [
                Expanded(
                  child: _favSong.isEmpty
                      ? const Center(
                          child: Text('No songs available'),
                        )
                      : ListView.builder(
                          itemCount: _favSong.length,
                          itemBuilder: (context, index) {
                            final song = _favSong[index];
                            debugPrint('${_favSong[0]}');
                            final albumArtImagePath = song['imageUrl'] ?? '';
                            final songName = song['title'];
                            final artistName =
                                song['artist'] ?? 'Unknown Artist';

                            return ListTile(
                              leading: albumArtImagePath.isEmpty
                                  ? const Icon(Icons.music_note, size: 50)
                                  : refactor.imagecropme(albumArtImagePath),
                              title: refactor.boldfonttxt(songName),
                              subtitle: Text(artistName),
                              trailing: IconButton(
                                onPressed: () async {
                                  await toggleFavorite(
                                      song); // Refresh favorite songs
                                },
                                icon: Icon(
                                  _favSong.any((favSong) =>
                                          favSong['id'] == song['id'])
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _favSong.any((favSong) =>
                                          favSong['id'] == song['id'])
                                      ? Colors.red
                                      : null,
                                ),
                              ),
                              onTap: () {
                                gotoSong(context, _favSong, index);
                              },
                            );
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
