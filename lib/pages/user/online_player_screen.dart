import 'package:beatz_musicplayer/pages/user/library.dart';
import 'package:flutter/material.dart';

class OnlineScreen extends StatefulWidget {
  const OnlineScreen({super.key});

  @override
  State<OnlineScreen> createState() => _OnlineScreenState();
}

class _OnlineScreenState extends State<OnlineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.favorite,
                                      size: 50,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(150, 100),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    label: const Text(
                                      'Liked \nSongs',
                                      style: TextStyle(fontSize: 18),
                                    )),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LibraryPage(),
                                          ));
                                    },
                                    icon: const Icon(
                                      Icons.music_note,
                                      size: 50,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(150, 100),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    label: const Text(
                                      'Explore \nGenres',
                                      style: TextStyle(fontSize: 18),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
    );
  }
}