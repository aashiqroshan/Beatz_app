import 'package:beatz_musicplayer/pages/user/online/all_songs_page.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> genres = [
      {'name': 'Pop', 'image': 'assets/images/pop.jpeg'},
      {'name': 'Melody', 'image': 'assets/images/melody.jpeg'},
      {'name': 'Country', 'image': 'assets/images/90s-Country.jpg'},
      {'name': 'Classical', 'image': 'assets/images/classic.jpeg'},
      {'name': 'Hindi', 'image': 'assets/images/hindi.jpeg'},
      {'name': 'Malayalam', 'image': 'assets/images/malayalam.jpeg'},
      {'name': 'Tamil', 'image': 'assets/images/tamil.jpeg'},
      {'name': 'Other', 'image': 'assets/images/other.jpeg'},
    ];
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SongListPage(),
                    ));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.inversePrimary)),
              child: const Text('All Songs')),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final String name = genres[index]['name'];
              final String image = genres[index]['image'];
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => GenreList(genre: name),
                  //     ));
                },
                child: Card(
                  color: Theme.of(context).colorScheme.background,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      Image.asset(
                        image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(name)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
