import 'package:beatz_musicplayer/components/continue_playing.dart';
import 'package:beatz_musicplayer/models/custom_playlist_service.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/add_songs_to_playlist.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({super.key, required this.playlistId});
  final String playlistId;
  final CustomPlaylistService customPlaylistService = CustomPlaylistService();

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
    final firebaseplay = Provider.of<FirebasePlaylistProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 65,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddSongsToPlaylist(playlistId: playlistId),
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: customPlaylistService.getPlaylist(playlistId),
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
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('Playlist not found'),
                  );
                }

                var playlistData =
                    snapshot.data!.data() as Map<String, dynamic>;
                var songIds = List<String>.from(playlistData['songIds'] ?? []);

                List<Map<String, dynamic>> songs = [];

                return ListView.builder(
                  itemCount: songIds.length,
                  itemBuilder: (context, index) {
                    var songId = songIds[index];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Songs')
                          .doc(songId)
                          .get(),
                      builder: (context, songSnapshot) {
                        if (songSnapshot.hasError) {
                          return Center(
                            child: Text('Error : ${songSnapshot.error}'),
                          );
                        }
                        if (songSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!songSnapshot.hasData ||
                            !songSnapshot.data!.exists) {
                          return const ListTile(
                            title: Text('Song not found'),
                          );
                        }

                        var songData =
                            songSnapshot.data!.data() as Map<String, dynamic>;
                        songs.add(songData);

                        return ListTile(
                            title: Text(songData['title']),
                            subtitle: Text(songData['artist']),
                            leading: Image.network(songData['imageUrl']),
                            trailing: IconButton(
                                onPressed: () {
                                  customPlaylistService.removeSongFromPlaylist(
                                      playlistId, songId);
                                },
                                icon: const Icon(Icons.delete)),
                            onTap: () {
                              gotoSong(context, songs, index);
                            });
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (firebaseplay.currentSongIndex != null)
            ContinuePlaying(
              songTitle: firebaseplay.playlist[firebaseplay.currentSongIndex!]
                  ['title'],
              artist: firebaseplay.playlist[firebaseplay.currentSongIndex!]
                  ['artist'],
              imageUrl: firebaseplay.playlist[firebaseplay.currentSongIndex!]
                  ['imageUrl'],
              onPlayPause: firebaseplay.pauseOrResume,
              onNext: firebaseplay.playNextSong,
              isPlaying: firebaseplay.isPlaying,
            ),
        ],
      ),
    );
  }
}
