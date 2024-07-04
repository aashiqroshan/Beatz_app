import 'dart:io';

import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/offline_playlist_model.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/user/offline/song_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class OfflinePlaylist extends StatefulWidget {
  const OfflinePlaylist({super.key});

  @override
  State<OfflinePlaylist> createState() => _OfflinePlaylistState();
}

class _OfflinePlaylistState extends State<OfflinePlaylist> {
  final Refactor refactor = Refactor();
  @override
  Widget build(BuildContext context) {
    final playlistBox = Hive.box<Playlist>('playlistBox');

    return Scaffold(
      appBar: refactor.appbartitles('Playlists'),
      body: ValueListenableBuilder(
        valueListenable: playlistBox.listenable(),
        builder: (context, Box<Playlist> box, _) {
          if (box.values.isEmpty) {
            return const Center(
              child: Text('No playlists added yet!'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final Playlist playlist = box.getAt(index) as Playlist;
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.inversePrimary),
                    height: 50,
                    width: 50,
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                  ),
                  title: refactor.boldfonttxt(playlist.name),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlaylistDetailsPage(
                        playlist: playlist,
                      ),
                    ));
                  },
                  trailing: IconButton(
                      onPressed: () {
                        box.deleteAt(index);
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showplaylist(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showplaylist(BuildContext context) {
    final namecontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Playlist'),
          content: TextField(
            controller: namecontroller,
            decoration: const InputDecoration(hintText: 'Playlist Name'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  final name = namecontroller.text;
                  if (name.isNotEmpty) {
                    final playlistBox = Hive.box<Playlist>('playlistBox');
                    final newPlaylist = Playlist(name: name, songs: []);
                    playlistBox.add(newPlaylist);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'))
          ],
        );
      },
    );
  }
}

class PlaylistDetailsPage extends StatefulWidget {
  final Playlist playlist;
  const PlaylistDetailsPage({super.key, required this.playlist});

  @override
  State<PlaylistDetailsPage> createState() => _PlaylistDetailsPageState();
}

class _PlaylistDetailsPageState extends State<PlaylistDetailsPage> {
  final Refactor refactor = Refactor();
  @override
  Widget build(BuildContext context) {
    final songBox = Hive.box<Song>('Box');
    final playlistProvider = Provider.of<PlaylistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: refactor.boldfonttxt(widget.playlist.name),
        actions: [
          IconButton(
              onPressed: () {
                showAddSongPlaylist(context, widget.playlist);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: widget.playlist.songs.isEmpty
          ? const Center(
              child: Text('No Songs added'),
            )
          : ListView.builder(
              itemCount: widget.playlist.songs.length,
              itemBuilder: (context, index) {
                final song = widget.playlist.songs[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3))
                    ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(song.albumArtImagePath),
                        fit: BoxFit.cover,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  title: Text(song.songName),
                  subtitle: Text(song.songName),
                  onTap: () {
                    playlistProvider.currentSongIndex =
                        songBox.values.toList().indexOf(song);
                    playlistProvider.play();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SongPage(),
                    ));
                  },
                  trailing: IconButton(
                      onPressed: () {
                        widget.playlist.songs.removeAt(index);
                        widget.playlist.save();
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete)),
                );
              },
            ),
    );
  }

  void showAddSongPlaylist(BuildContext context, Playlist playlist) {
    final Box<Song> songBox = Hive.box<Song>('Box');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Song to Playlist'),
          content: SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ValueListenableBuilder(
              valueListenable: songBox.listenable(),
              builder: (context, Box<Song> box, _) {
                if (box.values.isEmpty) {
                  return const Center(
                    child: Text('No songs available!'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final Song song = box.getAt(index) as Song;
                    return ListTile(
                      leading: Image.file(
                        File(song.albumArtImagePath),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ),
                      title: Text(song.songName),
                      subtitle: Text(song.artistName),
                      trailing: IconButton(
                          onPressed: () {
                            playlist.songs.add(song);
                            playlist.save();
                            setState(() {});
                          },
                          icon: const Icon(Icons.add)),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              label: const Text('Done'),
              icon: const Icon(Icons.check),
            )
          ],
        );
      },
    );
  }
}
