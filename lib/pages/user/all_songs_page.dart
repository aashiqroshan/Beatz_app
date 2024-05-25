import 'package:beatz_musicplayer/models/favService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({super.key});

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  final FavoriteService _favoriteService = FavoriteService();
  List<String> _favSongIds = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteSongs();
  }

  void fetchFavoriteSongs() async {
    List<String> favsongs = await _favoriteService.fetchFavSongs();
    setState(() {
      _favSongIds = favsongs;
    });
  }

  Future<void> toggleFavorite(String songId) async {
    if (_favSongIds.contains(songId)) {
      await _favoriteService.removeFromFav(songId);
    } else {
      await _favoriteService.addTofav(songId);
    }
    fetchFavoriteSongs(); // Refresh favorite songs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song List'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var song = snapshot.data!.docs[index];
              final isFavorite = _favSongIds.contains(song.id);

              return ListTile(
                title: Text(song['title']),
                subtitle: Text(song['artist']),
                leading: Image.network(
                  song['imageUrl'],
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    await toggleFavorite(song.id);
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
