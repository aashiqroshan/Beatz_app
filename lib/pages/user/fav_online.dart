import 'package:beatz_musicplayer/models/favService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavOnline extends StatefulWidget {
  const FavOnline({super.key});

  @override
  State<FavOnline> createState() => _FavOnlineState();
}

class _FavOnlineState extends State<FavOnline> {
  final FavoriteService _favoriteService = FavoriteService();
  List<Map<String, dynamic>> _songs = [];
  List<String> _favSongId = [];

  void fetchSongs() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Songs').get();
    setState(() {
      _songs = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  void fetchFaovrite() async {
    List<String> favsongs = await _favoriteService.fetchFavSongs();
    setState(() {
      _favSongId = favsongs;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSongs();
    fetchFaovrite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _songs.isEmpty
            ? const Center(
                child: Text('No songs in it'),
              )
            : ListView.builder(
                itemCount: _songs.length,
                itemBuilder: (context, index) {
                  final song = _songs[index];
                  final isFavorite = _favSongId.contains(song['id']);
                  return ListTile(
                    leading: Image.network(
                      song['albumArtImagePath'],
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(song['songName']),
                    subtitle: Text(song['artistName']),
                    trailing: IconButton(
                        onPressed: () async {
                          if (isFavorite) {
                            await _favoriteService.removeFromFav(song['id']);
                          } else {
                            await _favoriteService.addTofav(song['id']);
                          }
                          fetchFaovrite();
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        )),
                  );
                },
              ));
  }
}
