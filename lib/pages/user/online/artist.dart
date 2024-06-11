import 'package:beatz_musicplayer/pages/user/online/artist_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArtistList extends StatefulWidget {
  const ArtistList({super.key});

  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Artist list'),),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Songs').snapshots(),
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

          final artist = snapshot.data!.docs
              .map((doc) => doc['artist'] as String)
              .toSet()
              .toList();
          if (artist.isEmpty) {
            return const Center(
              child: Text('No language found'),
            );
          }

          return ListView.builder(
            itemCount: artist.length,
            itemBuilder: (context, index) {
              final artists = artist[index];
              return ListTile(
                title: Text(artists),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistPage(artist: artists),));
                },
              );
            },
          );
        },
      ),
    );
  }
}
