import 'package:beatz_musicplayer/models/custom_playlist_service.dart';
import 'package:flutter/material.dart';

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({super.key});

  @override
  State<CreatePlaylist> createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  TextEditingController playlistname = TextEditingController();
  CustomPlaylistService customPlaylistService = CustomPlaylistService();

  void _createPlaylist() {
    if (playlistname.text.isNotEmpty) {
      customPlaylistService.createPlaylist(playlistname.text);
      playlistname.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text('Name Your Playlist'),
      content: SingleChildScrollView(
          child: Column(
        children: [
          TextField(
            controller: playlistname,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    _createPlaylist();
                    Navigator.pop(context);
                  },
                  child: const Text('Create')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
          )
        ],
      )),
    );
  }

 
}
