import 'dart:io';

import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SongPage extends StatelessWidget {
  const SongPage({super.key});
  String formatTime(Duration duration) {
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    String formattedTime = "${duration.inMinutes}:$twoDigitSeconds";
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;
        if (playlist.isEmpty) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(child: Center(child: Text('No songs in the playlist!',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),)),
          );
        }
        final currentSong = playlist[value.currentSongIndex ?? 0];
        final isfavorite = value.isFavorite(currentSong.songName);
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Text('PLAYER'),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
                  ],
                ),
                // SizedBox(
                //   height: 30,
                // ),
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3))
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(
                        currentSong.albumArtImagePath,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(currentSong.artistName)
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          isfavorite ? Icons.favorite : Icons.favorite_border,
                          color: isfavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          value.toggleFavorite(currentSong.songName);
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatTime(value.currentDuration)),
                      const Icon(Icons.shuffle),
                      const Icon(Icons.repeat),
                      Text(formatTime(value.totalDuration))
                    ],
                  ),
                ),
                SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 5)),
                    child: Slider(
                      min: 0,
                      max: value.totalDuration.inSeconds.toDouble(),
                      value: value.currentDuration.inSeconds.toDouble(),
                      onChanged: (double double) {},
                      onChangeEnd: (double double) {
                        value.seek(Duration(seconds: double.toInt()));
                      },
                    )),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playPreviousSong,
                        child: const Icon(
                          Icons.skip_previous,
                          size: 50,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: value.pauseOrResume,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.black, shape: BoxShape.circle),
                          height: 80,
                          width: 80,
                          child: Icon(
                            value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: value.playNextSong,
                        child: const Icon(
                          Icons.skip_next,
                          size: 50,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
