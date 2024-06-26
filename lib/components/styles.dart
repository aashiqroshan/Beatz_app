import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:flutter/widgets.dart';

class Refactor {
  Widget likeListview(
      {required List<Map<String, dynamic>> items,
      required Function(BuildContext, List<Map<String, dynamic>>, int) onTapf,
      required Future<void> Function(Map<String, dynamic>) ontapt,
      required List<String> favSongid}) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isFav = favSongid.contains(item['id']);
        return ListTile(
          title: titletext(item['title']),
          subtitle: Text(item['artist']),
          leading: imagecropme(
            item['imageUrl'],
          ),
          onTap: () {
            onTapf(context, items, index);
          },
          trailing: IconButton(
              onPressed: () async {
                await ontapt(item);
              },
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              )),
        );
      },
    );
  }

  Widget laglistviewbuilder(
      {required List<String> items, required Widget Function(String) pageReq}) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pageReq(item),
                ));
          },
        );
      },
    );
  }

  Widget abc(String word) {
    return Text(
      word,
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget settings(
      {required BuildContext context,
      required String title,
      required IconData icons,
      required Widget pageReq}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pageReq,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icons),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }

  Widget offlineListview(
      {required Song song,
      required int index,
      required Function(int index) goto,
      required Function toggle,
      required Function(String) isFav}) {
    return ListTile(
      leading: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3))
        ]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(song.albumArtImagePath),
              fit: BoxFit.cover,
              height: 50,
              width: 50,
            )),
      ),
      title: titletext(song.songName),
      subtitle: Text(song.artistName),
      onTap: () => goto(index),
      trailing: IconButton(
          onPressed: () => toggle(song.songName),
          icon: Icon(
            isFav(song.songName) ? Icons.favorite : Icons.favorite_border,
            color: isFav(song.songName) ? Colors.red : null,
          )),
    );
  }

  Widget boldfontstyle(String abc) {
    return Text(
      abc,
      style: const TextStyle(
          fontFamily: 'Poppins', fontSize: 25, fontWeight: FontWeight.w600),
    );
  }

  Widget titletext(String abc) {
    return Text(
      abc,
      style:
          const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
    );
  }

  Widget imagecropme(String src) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3))
      ]),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            src,
            fit: BoxFit.cover,
            height: 50,
            width: 50,
          )),
    );
  }

  Widget boldfonttxt(String abc) {
    return Text(
      abc,
      style:
          const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
    );
  }

  PreferredSizeWidget appbartitles(String abc) {
    return AppBar(
      title: Text(abc,style: const TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),
      centerTitle: true,
    );
  }
}
