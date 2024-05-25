import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GenreList extends StatefulWidget {
  // ignore: use_super_parameters
  const GenreList({Key? key, required this.genre}) : super(key: key);
  final String genre;

  @override
  State<GenreList> createState() => _GenreListState();
}

class _GenreListState extends State<GenreList> {
  @override
  void initState() {
    debugPrint("genre = ${widget.genre}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('this is ${widget.genre} page'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Songs')
            .where('genre', isEqualTo: widget.genre)
            .snapshots(),
        builder: (context, snapshot) {
          debugPrint("snapshot =");
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('there are no songs in this genre'),
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
              debugPrint('Item count: ${snapshot.data?.docs.length}');
              return ListTile(
                title: Text(song['title']),
                subtitle: Text(song['artist']),
                leading: Image.network(song['imageUrl']),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }
}
