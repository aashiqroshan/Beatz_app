import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSong extends StatefulWidget {
  const AddSong({super.key});

  @override
  State<AddSong> createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController lyricsController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  late String imagepath;
  late String audiopath;
  final List<String> genres = [
    'Pop',
    'melody',
    'Country',
    'Classical',
    'hindi',
    'malayalam',
    'tamil',
    'Other'
  ];

  Future<void> uploadSong({
    required String title,
    required String artist,
    required String genre,
    required String lanuage,
    required String lyrics,
    required String imagePath,
    required String audioPath,
  }) async {
    firebase_storage.Reference imageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    await imageRef.putFile(File(imagePath));

    String imageUrl = await imageRef.getDownloadURL();

    firebase_storage.Reference audioRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('audio/${DateTime.now().millisecondsSinceEpoch}.mp3');
    await audioRef.putFile(File(audioPath));

    String audioUrl = await audioRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('Songs').add({
      'title': title,
      'artist': artist,
      'genre': genre,
      'language': lanuage,
      'lyrics': lyrics,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
    });
  }

  Future<String?> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp3']);
    if (result != null) {
      return result.files.single.path;
    } else {
      return null;
    }
  }

  Future<String?> pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      return result.files.single.path;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back)),
                    const Text(
                      'Add songs',
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField( 
                  controller: titleController,
                  decoration: InputDecoration(
                      label: const Text('Song title'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: artistController,
                  decoration: InputDecoration(
                      label: const Text('Song artist'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                    controller: languageController,
                    decoration: InputDecoration(
                        label: const Text('Song Language'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)))),
                const SizedBox(
                  height: 30,
                ),
                DropdownButtonFormField<String>(
                  value: genreController.text.isNotEmpty &&
                          genres.contains(genreController.text)
                      ? genreController.text
                      : null,
                  onChanged: (value) {
                    setState(() {
                      genreController.text = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Song genre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  items: genres.map((genre) {
                    return DropdownMenuItem<String>(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: lyricsController,
                  decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 50, bottom: 50, left: 20),
                      label: const Text('Song lyrics'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          String? audiofilepath = await pickAudioFile();
                          if (audiofilepath != null) {
                            audiopath = audiofilepath;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('audio selected')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('audio error occured ')));
                          }
                        },
                        child: const Text('Select AudioFile')),
                    ElevatedButton(
                        onPressed: () async {
                          String? imagefilepath = await pickImageFile();
                          if (imagefilepath != null) {
                            imagepath = imagefilepath;
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('image selected')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('image error occured')));
                          }
                        },
                        child: const Text('Select Image'))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await uploadSong(
                                title: titleController.text,
                                artist: artistController.text,
                                genre: genreController.text,
                                lanuage: languageController.text,
                                lyrics: lyricsController.text,
                                imagePath: imagepath,
                                audioPath: audiopath);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('upload successful')));
                            Navigator.of(context).pop();
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('upload error occured')));
                          }
                        },
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll<Color>(Colors.red),
                            foregroundColor:
                                MaterialStatePropertyAll<Color>(Colors.black)),
                        child: const Text('Upload')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: const ButtonStyle(
                            foregroundColor:
                                MaterialStatePropertyAll(Colors.black),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        child: const Text('cancel'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
