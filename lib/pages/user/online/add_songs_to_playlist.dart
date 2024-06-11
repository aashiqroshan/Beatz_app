import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSongsToPlaylist extends StatelessWidget {
  const AddSongsToPlaylist({super.key, required this.playlistId});
  final String playlistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Songs to Playlist'),
      ),
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
                leading: Image.network(song['imageUrl']),
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
