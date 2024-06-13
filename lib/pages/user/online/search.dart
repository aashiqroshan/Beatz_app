import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/favService.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Refactor refactor = Refactor();
  late String _searchQuery = '';
  final FavoriteService favoriteService = FavoriteService();
  List<String> _favSongsId = [];

  @override
  void initState() {
    super.initState();
    fetchFavSongs();
  }

  void fetchFavSongs() async {
    try {
      List<Map<String, dynamic>> favSongs =
          await favoriteService.fetchFavSongs();
      setState(() {
        _favSongsId = favSongs.map((song) => song['id'] as String).toList();
      });
    } catch (e) {
      debugPrint('error in search for getting songs');
    }
  }

  Future<void> toggleFav(Map<String, dynamic> song) async {
    if (_favSongsId.contains(song['id'])) {
      await favoriteService.removeFromFav(song['id']);
    } else {
      await favoriteService.addTofav(song);
    }
    fetchFavSongs();
  }

  void gotoSong(BuildContext context, List<Map<String, dynamic>> playlist,
      int songIndex) {
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
        title: const Text('Search songs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search by song name or artist',
                  prefixIcon: Icon(Icons.search)),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('Songs').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var songs = snapshot.data!.docs
                  .where((song) =>
                      song['title'].toLowerCase().contains(_searchQuery) ||
                      song['artist'].toLowerCase().contains(_searchQuery))
                  .toList();
              var songlist = songs.map((doc) => doc.data()).toList();
              return refactor.likeListview(
                  items: songlist,
                  onTapf: gotoSong,
                  ontapt: toggleFav,
                  favSongid: _favSongsId);
            },
          ))
        ],
      ),
    );
  }
}
