import 'package:beatz_musicplayer/models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: TextField(
              decoration: const InputDecoration(
                  hintText: 'Search by song name or artist',
                  prefixIcon: Icon(Icons.search)),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Songs')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error : ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var songs = snapshot.data!.docs.where((song) =>
                  song['title'].toLowerCase().contains(_searchQuery) ||
                  song['artist'].toLowerCase().contains(_searchQuery));
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  var song = songs.elementAt(index);
                  return ListTile(
                    title: Text(
                      song['title'],
                    ),
                    subtitle: Text(song['artist']),
                    leading: Image.network(song['imageUrl']),
                    onTap: () {},
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
