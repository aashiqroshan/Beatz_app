import 'dart:io';

import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/user/offline/song_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineSearch extends StatefulWidget {
  const OfflineSearch({super.key});

  @override
  State<OfflineSearch> createState() => _OfflineSearchState();
}

class _OfflineSearchState extends State<OfflineSearch> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  late PlaylistProvider playlistProvider;
  final Refactor refactor = Refactor();

  void gotoSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    playlistProvider.play();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final songBox = Hive.box<Song>('Box');
    final favBox = Hive.box<String>('favBox');
    return Scaffold(
        appBar: refactor.appbartitles('Seach songs'),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                    label: const Text('Search songs'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          searchQuery = '';
                        },
                        icon: const Icon(Icons.clear))),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              Expanded(
                  child: ValueListenableBuilder(
                valueListenable: songBox.listenable(),
                builder: (context, Box<Song> box, _) {
                  final allSongs = box.values.toList();

                  final filteredSongs = allSongs
                      .where((song) =>
                          song.songName
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          song.artistName
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                      .toList();

                  if (filteredSongs.isEmpty) {
                    return const Center(
                      child: Text('no songs found!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final Song song = filteredSongs[index];
                      return ListTile(
                        title: Text(song.songName),
                        subtitle: Text(song.artistName),
                        leading: Image.file(
                          File(song.albumArtImagePath),
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          gotoSong(index);
                        },
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                if (favBox.containsKey(song.songName)) {
                                  favBox.delete(song.songName);
                                } else {
                                  favBox.put(song.songName, song.songName);
                                }
                              });
                            },
                            icon: Icon(
                              favBox.containsKey(song.songName)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favBox.containsKey(song.songName)
                                  ? Colors.red
                                  : null,
                            )),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        ));
  }
}
