import 'package:beatz_musicplayer/components/admin_playlist.dart';
import 'package:beatz_musicplayer/components/my_drawer.dart';
import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/pages/admin/admin_playlist_page.dart';
import 'package:beatz_musicplayer/pages/admin/upload_song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Refactor refactor = Refactor();
    return Scaffold(
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddSong(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Builder(builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.solidCircleUser,
                          size: 50,
                        )),
                    const Text(
                      'Welcome Admin',
                      style: TextStyle(fontSize: 20),
                    ),
                    Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              showbox(context);
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.solidSquarePlus,
                              size: 30,
                            )),
                        const Text('Playlist')
                      ],
                    )
                  ],
                );
              }),
              const SizedBox(
                height: 20,
              ),
              refactor.boldfontstyle('Admin Playlist'),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('AdminPlaylist')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var playlists = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: playlists.length,
                    itemBuilder: (context, index) {
                      var playlist = playlists[index].data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminPlaylistPage(playlistId: playlists[index].id, playlistName: playlist['name'], playlistImageUrl: playlist['imageUrl']),)
                          );
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  playlist['imageUrl'],
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(playlist['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }

  void showbox(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AdminPlaylist(),
    );
  }
}
