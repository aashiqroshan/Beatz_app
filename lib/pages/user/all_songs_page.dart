import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SongListPage extends StatelessWidget {
  const SongListPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song List'),
      ),
      body: StreamBuilder
      <QuerySnapshot<Map<String, dynamic>>>(
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var song = snapshot.data!.docs[index];
              return ListTile(
                title: Text(song['title']),
                subtitle: Text(song['artist']),
                leading: Image.network(song['imageUrl']),
                onTap: () {
                  // Add onTap logic here
                },
              );
            },
          );
        },
      ),
    );
  }
}
