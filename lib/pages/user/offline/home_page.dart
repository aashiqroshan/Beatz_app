import 'dart:io';

import 'package:beatz_musicplayer/components/my_drawer.dart';
import 'package:beatz_musicplayer/components/showdialoguebox.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/user/offline/offline_fav.dart';
import 'package:beatz_musicplayer/pages/user/offline/offline_playlist.dart';
import 'package:beatz_musicplayer/pages/user/offline/offline_search.dart';
import 'package:beatz_musicplayer/pages/user/offline/song_page.dart';
import 'package:flutter/material.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Refactor refactor = Refactor();
  late Box<Song> songBox;
  late Box<String> favoriteBox;
  late PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    songBox = Hive.box<Song>('Box');
    favoriteBox = Hive.box<String>('favBox');
    Future.delayed(Duration.zero, () {
      playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    });
  }

  void gotoSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    playlistProvider.play();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ));
  }

  void toggleFavorite(String songId) {
    setState(() {
      if (favoriteBox.containsKey(songId)) {
        favoriteBox.delete(songId);
      } else {
        favoriteBox.put(songId, songId);
      }
    });
  }

  bool isFavorite(String songId) {
    return favoriteBox.containsKey(songId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        drawer: const MyDrawer(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: FloatingActionButton(
                        onPressed: () {
                          showAddSongDialog(context);
                        },
                        child: const Icon(Icons.upload),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const OfflineSearch(),
                          ));
                        },
                        child: const Icon(Icons.search),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FavOffline(),
                        ));
                      },
                      child: const Icon(Icons.favorite),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OfflinePlaylist(),
                              ));
                        },
                        child: const FaIcon(FontAwesomeIcons.headphones))
                  ],
                )
              ],
            )
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                Builder(builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Opens the drawer
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.solidCircleUser,
                      size: 50,
                    ),
                  );
                }),
                refactor.boldfontstyle('Welcome User!')
              ],
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: songBox.listenable(),
                  builder: (context, Box<Song> box, _) {
                    if (box.values.isEmpty) {
                      return const Center(
                        child: Text('No songs added yet!'),
                      );
                    }
                    return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        {
                          final Song song = box.getAt(index) as Song;
                          return refactor.offlineListview(
                              song: song,
                              index: index,
                              goto: gotoSong,
                              toggle: toggleFavorite,
                              isFav: isFavorite);
                        }
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void showAddSongDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddSongBox(),
    );
  }
}
