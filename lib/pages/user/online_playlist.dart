import 'package:beatz_musicplayer/components/bottm_navigator.dart';
import 'package:beatz_musicplayer/pages/user/all_songs_page.dart';
import 'package:beatz_musicplayer/pages/user/fav_online.dart';
import 'package:beatz_musicplayer/pages/user/library.dart';
import 'package:flutter/material.dart';

class OnlinePlaylist extends StatefulWidget {
  const OnlinePlaylist({super.key});

  @override
  State<OnlinePlaylist> createState() => _OnlinePlaylistState();
}

class _OnlinePlaylistState extends State<OnlinePlaylist> {
  void likedsongsfunction() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FavOnline()));
  }

  void languagesongsfunction() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BottomNavi(),
    ));
  }

  void artistsongsfunction() {
    Navigator.of(context).pop();
  }

  void genresongsfunction() {
    Navigator.of(context).pop();
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
        'image': 'assets/images/liked.jpg',
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
        'image': 'assets/images/cassette.jpg',
        'ontap': allsongssongsfunction
      }
    ];
  }

  @override
  Widget build(BuildContext context) {
    final playlisttypes = getplaylisttypes();
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: playlisttypes.length,
        itemBuilder: (context, index) {
          final typeName = playlisttypes[index]['name'];
          final typeImage = playlisttypes[index]['image'];
          final tapfuntions = playlisttypes[index]['ontap'] as VoidCallback;
          return ListTile(
            leading: Image.asset(
              typeImage,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
            title: Text(typeName),
            onTap: tapfuntions,
          );
        },
      ),
    );
  }
}
