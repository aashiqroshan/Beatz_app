import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/models/firebase_playlist_provider.dart';
import 'package:beatz_musicplayer/pages/admin/admin_playlist_page.dart';
import 'package:beatz_musicplayer/pages/user/online/fav_online.dart';
import 'package:beatz_musicplayer/pages/user/online/online_playlist.dart';
import 'package:beatz_musicplayer/pages/user/online/online_song_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnlineScreen extends StatefulWidget {
  const OnlineScreen({super.key});

  @override
  State<OnlineScreen> createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Refactor refactor = Refactor();

  void gotoSong(BuildContext context, List<Map<String, dynamic>> playlist,
      int songIndex) async {
    final firebasePlay =
        Provider.of<FirebasePlaylistProvider>(context, listen: false);
    firebasePlay.setPlaylist(playlist, songIndex);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OnlineSongPage(playlist: playlist, songIndex: songIndex),
        ));
  }

  Widget buildSongTile(BuildContext context, Map<String, dynamic> song,
      int songIndex, bool isPlaying) {
    final firebasePlaylistProvider =
        Provider.of<FirebasePlaylistProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.inversePrimary),
      child: ListTile(
        leading: Image.network(song['imageUrl']),
        title: Text(
          song['title'],
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        subtitle: Text(
          song['artist'],
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        trailing: Container(
          height: 70,
          width: 70,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: IconButton(
              onPressed: () => gotoSong(
                  context, firebasePlaylistProvider.playlist, songIndex),
              icon: isPlaying
                  ? const Icon(
                      Icons.pause,
                      size: 40,
                    )
                  : const Icon(
                      Icons.play_arrow,
                      size: 40,
                    )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebasePlaylistProvider =
        Provider.of<FirebasePlaylistProvider>(context);
    return Scaffold(
      appBar: refactor.appbartitles('Online player'),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavOnline(),
                          ));
                    },
                    icon: const Icon(
                      Icons.favorite,
                      size: 50,
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 100),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    label: const Text(
                      'Liked \nSongs',
                      style: TextStyle(fontSize: 18),
                    )),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnlinePlaylist(),
                          ));
                    },
                    icon: const Icon(
                      Icons.music_note,
                      size: 50,
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(150, 100),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    label: const Text(
                      'Explore \nGenres',
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              children: [
                Text(
                  'Continue Playing',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
                Spacer()
              ],
            ),
            firebasePlaylistProvider.currentSongIndex != null
                ? Container(
                    width: double.infinity,
                    height: 90,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        final songindex =
                            firebasePlaylistProvider.currentSongIndex;
                        final song = firebasePlaylistProvider.playlist[
                            firebasePlaylistProvider.currentSongIndex!];
                        return Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(song['imageUrl'])),
                            title: Text(
                              song['title'],
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            subtitle: Text(
                              song['artist'],
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            trailing: Container(
                              height: 70,
                              width: 70,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: IconButton(
                                  onPressed:
                                      firebasePlaylistProvider.pauseOrResume,
                                  icon: firebasePlaylistProvider.isPlaying
                                      ? const Icon(
                                          Icons.pause,
                                          size: 40,
                                        )
                                      : const Icon(
                                          Icons.play_arrow,
                                          size: 40,
                                        )),
                            ),
                            onTap: () {
                              gotoSong(
                                  context,
                                  firebasePlaylistProvider.playlist,
                                  songindex!);
                            },
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text('No song is currently playing'),
                  ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _firestore.collection('AdminPlaylist').snapshots(),
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
                      var playlists = snapshot.data!.docs;
                      return GridView.builder(
                        itemCount: playlists.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.75),
                        itemBuilder: (context, index) {
                          final playlist = playlists[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminPlaylistPage(
                                        playlistId: playlists[index].id,
                                        playlistName: playlist['name'],
                                        playlistImageUrl: playlist['imageUrl']),
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: Image.network(
                                      playlist['imageUrl'],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          playlist['name'],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
