import 'package:beatz_musicplayer/components/bottom_nav.dart';
import 'package:beatz_musicplayer/components/my_drawer.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/user/song_page.dart';
import 'package:beatz_musicplayer/pages/user/library.dart';
import 'package:flutter/material.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void gotoSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SongPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            drawer: const MyDrawer(),
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
                    const Text(
                      'Welcome user!',
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
                const TabBar(
                  tabs: [
                    Tab(
                      text: 'Local songs',
                    ),
                    Tab(
                      text: 'Online',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Consumer<PlaylistProvider>(
                          builder: (context, value, child) {
                        final List<Song> playlist = value.playlist;

                        return ListView.builder(
                          itemCount: playlist.length,
                          itemBuilder: (context, index) {
                            final Song song = playlist[index];
                            return ListTile(
                              title: Text(song.songName),
                              subtitle: Text(song.artistName),
                              leading: Image.asset(song.albumArtImagePath),
                              onTap: () => gotoSong(index),
                            );
                          },
                        );
                      }),
                      Container(
                        child: Column(
                          children: [
                           const  SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite,
                                      size: 50,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(180, 100),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    label: const Text(
                                      'Liked \nSongs',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LibraryPage(),));
                                    },
                                    icon: const Icon(
                                      Icons.music_note,
                                      size: 50,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const  Size(180, 100),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    label: const Text(
                                      'Explore \nGenres',
                                      style: TextStyle(fontSize: 18),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: const BottomNav()),
      ),
    );
  }
}
