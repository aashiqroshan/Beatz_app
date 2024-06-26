import 'package:beatz_musicplayer/components/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSongsToPlaylist extends StatelessWidget {
  AddSongsToPlaylist({super.key, required this.playlistId});
  final String playlistId;
  final Refactor refactor = Refactor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: refactor.appbartitles('Add songs to Playlist'),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Songs').snapshots(),
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
              var song = songs[index].data() as Map<String, dynamic>;
              var songId = songs[index].id;

              return ListTile(
                title: Text(song['title']),
                subtitle: Text(song['artist']),
                leading: refactor.imagecropme(song['imageUrl']),
                trailing: IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('playlists')
                          .doc(playlistId)
                          .update({
                        'songIds': FieldValue.arrayUnion([songId])
                      });
                    },
                    icon: const Icon(Icons.add)),
              );
            },
          );
        },
      ),
    );
  }
}
