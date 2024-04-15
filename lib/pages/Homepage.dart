import 'package:beatz_musicplayer/components/my_drawer.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/song_page.dart';
import 'package:flutter/material.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
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
    // TODO: implement initState
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void gotoSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SongPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          drawer: MyDrawer(),
          body: Column(
            children: [
              Row(
                children: [
                  Builder(builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer(); // Opens the drawer
                      },
                      icon: Icon(
                        Icons.person_pin,
                        size: 50,
                      ),
                    );
                  }),
                  Text(
                    'Welcome user!',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              TabBar(
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
                    Consumer<PlaylistProvider>(builder: (context, value, child) {
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
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
