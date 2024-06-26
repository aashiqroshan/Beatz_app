import 'package:beatz_musicplayer/components/create_playlist.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/custom_playlist_service.dart';
import 'package:beatz_musicplayer/pages/user/online/all_songs_page.dart';
import 'package:beatz_musicplayer/pages/user/online/artist.dart';
import 'package:beatz_musicplayer/pages/user/online/each_playlist_page.dart';
import 'package:beatz_musicplayer/pages/user/online/fav_online.dart';
import 'package:beatz_musicplayer/pages/user/online/genre.dart';
import 'package:beatz_musicplayer/pages/user/online/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnlinePlaylist extends StatefulWidget {
  const OnlinePlaylist({super.key});

  @override
  State<OnlinePlaylist> createState() => _OnlinePlaylistState();
}

class _OnlinePlaylistState extends State<OnlinePlaylist> {
  final Refactor refactor = Refactor();
  CustomPlaylistService customPlaylistService = CustomPlaylistService();
  void likedsongsfunction() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FavOnline()));
  }

  void languagesongsfunction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LanguageList(),
    ));
  }

  void artistsongsfunction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ArtistList(),
    ));
  }

  void genresongsfunction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const GenreList(),
    ));
  }

  void allsongssongsfunction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SongListPage(),
    ));
  }

  List<Map<String, dynamic>> getplaylisttypes() {
    return [
      {
        'name': 'Liked Songs',
        'image': 'assets/images/liked.png',
        'ontap': likedsongsfunction
      },
      {
        'name': 'Language',
        'image': 'assets/images/language.png',
        'ontap': languagesongsfunction
      },
      {
        'name': 'Artist',
        'image': 'assets/images/artist.png',
        'ontap': artistsongsfunction
      },
      {
        'name': 'Genre',
        'image': 'assets/images/genre.png',
        'ontap': genresongsfunction
      },
      {
        'name': 'All songs',
        'image': 'assets/images/star.png',
        'ontap': allsongssongsfunction
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final playlisttypes = getplaylisttypes();
    return Scaffold(
      appBar: refactor.appbartitles('PLaylists'),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(10),
        width: 100,
        height: 70,
        child: FloatingActionButton(
            onPressed: () {
              showbox(context);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.add), Text('Create \nPlaylist')],
            )),
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlisttypes.length,
            itemBuilder: (context, index) {
              final typeName = playlisttypes[index]['name'];
              final typeImage = playlisttypes[index]['image'];
              final tapfuntions = playlisttypes[index]['ontap'] as VoidCallback;
              return ListTile(
                contentPadding: const EdgeInsets.all(15),
                leading: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3))
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      typeImage,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  typeName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: tapfuntions,
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('playlists').snapshots(),
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
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No playlists found"),
                );
              }
              var playlists = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var playlist = playlists[index];
                  var playlistData = playlist.data() as Map<String, dynamic>;
                  return ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3))
                          ],
                          borderRadius: BorderRadius.circular(8)),
                      height: 50,
                      width: 50,
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      playlistData['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlaylistPage(playlistId: playlist.id),
                          ));
                    },
                    trailing: IconButton(
                        onPressed: () {
                          customPlaylistService.deletePlaylist(playlist.id);
                        },
                        icon: const Icon(Icons.delete)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void showbox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreatePlaylist(),
    );
  }
}
