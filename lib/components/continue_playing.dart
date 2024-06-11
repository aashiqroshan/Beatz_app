import 'package:flutter/material.dart';

class ContinuePlaying extends StatelessWidget {
  final String songTitle;
  final String artist;
  final String imageUrl;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final bool isPlaying;

  ContinuePlaying(
      {super.key,
      required this.songTitle,
      required this.artist,
      required this.imageUrl,
      required this.onPlayPause,
      required this.onNext,
      required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey[900],
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                songTitle,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                artist,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
          const Spacer(),
          IconButton(
              onPressed: onPlayPause,
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              )),
          IconButton(
              onPressed: onNext,
              icon: const Icon(
                Icons.skip_next,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
