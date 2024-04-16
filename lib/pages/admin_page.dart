import 'package:beatz_musicplayer/components/my_drawer.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(onPressed: () {},child: Icon(Icons.add),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
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
                        icon: Icon(Icons.person_pin)),
                    Text('Welcome Admin'),
                    IconButton(onPressed: () {}, icon: Icon(Icons.person))
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
