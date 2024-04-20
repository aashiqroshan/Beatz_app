import 'package:beatz_musicplayer/components/my_drawer.dart';
import 'package:beatz_musicplayer/pages/add_songs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSong(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Builder(builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.solidCircleUser,
                          size: 50,
                        )),
                    Text(
                      'Welcome Admin',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          FontAwesomeIcons.users,
                          size: 30,
                        ))
                  ],
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
