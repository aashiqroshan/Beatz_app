import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/pages/user/online/genre_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenreList extends StatefulWidget {
  const GenreList({super.key});

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  final Refactor refactor = Refactor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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

          final genre = snapshot.data!.docs
              .map((doc) => doc['genre'] as String)
              .toSet()
              .toList();

          if (genre.isEmpty) {
            return const Center(
              child: Text('No genre found'),
            );
          }

          return refactor.laglistviewbuilder(
            items: genre,
            pageReq: (genre) => GenrePage(genres: genre),
          );
        },
      ),
    );
  }
}
