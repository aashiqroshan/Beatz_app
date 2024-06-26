import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPlaylistPage extends StatefulWidget {
  final String playlistId;
  final String playlistName;
  final String playlistImageUrl;
  const AdminPlaylistPage(
      {super.key,
      required this.playlistId,
      required this.playlistName,
      required this.playlistImageUrl});

  @override
  State<AdminPlaylistPage> createState() => _AdminPlaylistPageState();
}

class _AdminPlaylistPageState extends State<AdminPlaylistPage> {
  final Refactor refactor = Refactor();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addsongToplaylist(String songId) async {
    try {
      await _firestore
          .collection('AdminPlaylist')
          .doc(widget.playlistId)
          .update({
        'songs': FieldValue.arrayUnion([songId])
      });
    } catch (e) {
      debugPrint('Error adding song to playlist: $e');
    }
  }

  Future<void> removesongfromPlaylist(String songID) async {
    try {
      await _firestore
          .collection('AdminPlaylist')
          .doc(widget.playlistId)
          .update({
        'songs': FieldValue.arrayRemove([songID])
      });
    } catch (e) {
      debugPrint('Error removing song from playlist: $e');
    }
  }

  void showAddSongDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Song to playlist'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _firestore.collection('Songs').snapshots(),
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
                var songs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    var song = songs[index].data();
                    return ListTile(
                      leading: Image.network(
                        song['imageUrl'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(song['title']),
                      onTap: () {
                        addsongToplaylist(songs[index].id);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'))
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> getSongDetails(String songId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> songDoc =
          await _firestore.collection('Songs').doc(songId).get();
      return songDoc.data() ?? {};
    } catch (e) {
      debugPrint('Error fetching song details: $e');
      return {};
    }
  }

  void gotoSong(BuildContext context, List<Map<String, dynamic>> playlist,
      int songIndex) async {
    final firebasePlay =
        Provider.of<FirebasePlaylistProvider>(context, listen: false);
    firebasePlay.setPlaylist(playlist, songIndex);
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
        title: Text(widget.playlistName),
      ),
      body: Column(
        children: [
          Image.network(
            widget.playlistImageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _firestore
                .collection('AdminPlaylist')
                .doc(widget.playlistId)
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

              var playlistData = snapshot.data!.data();

              List<dynamic> songIds = playlistData?['songs'] ?? [];

              return ListView.builder(
                itemCount: songIds.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: getSongDetails(songIds[index]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Loading....'),
                        );
                      }
                      if (snapshot.hasError) {
                        return ListTile(
                          title: Text('Error: ${snapshot.error}'),
                        );
                      }
                      var songDetails = snapshot.data!;
                      return ListTile(
                        leading: Image.network(
                          songDetails['imageUrl'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: refactor.boldfonttxt(songDetails['title']),
                        subtitle: Text(songDetails['artist']),
                        onTap: () {
                          // gotoSong(context, songIds, index)
                        },
                        trailing: IconButton(
                            onPressed: () {
                              removesongfromPlaylist(songIds[index]);
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    },
                  );
                },
              );
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSongDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
