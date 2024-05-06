import 'package:beatz_musicplayer/pages/user/library.dart';
import 'package:beatz_musicplayer/pages/user/search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.house,
                  color: Theme.of(context).colorScheme.secondary,
                )),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ));
                },
                icon: FaIcon(FontAwesomeIcons.magnifyingGlass,
                    color: Theme.of(context).colorScheme.secondary)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LibraryPage(),
                      ));
                },
                icon: FaIcon(
                  FontAwesomeIcons.layerGroup,
                  color: Theme.of(context).colorScheme.secondary,
                ))
          ],
        ),
      ),
    );
  }
}
