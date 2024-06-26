import 'dart:io';

import 'package:beatz_musicplayer/models/custom_playlist_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminPlaylist extends StatefulWidget {
  const AdminPlaylist({super.key});

  @override
  State<AdminPlaylist> createState() => _AdminPlaylistState();
}

class _AdminPlaylistState extends State<AdminPlaylist> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CustomPlaylistService customPlaylistService = CustomPlaylistService();
  TextEditingController playlistname = TextEditingController();
  String? imageUrl;

  Future<String?> pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png']);
    if (result != null) {
      File file = File(result.files.single.path!);
      return uploadFile(file);
    }
    return null;
  }

  Future<String?> uploadFile(File file) async {
    try {
      String fileName =
          'playlist_images/${DateTime.now().microsecondsSinceEpoch}.jpg';
      TaskSnapshot snapshot =
          await FirebaseStorage.instance.ref().child(fileName).putFile(file);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> createPlaylist() async {
    if (playlistname.text.isNotEmpty) {
      customPlaylistService.createadminplaylist(playlistname.text, imageUrl);
      playlistname.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Name The Playlist'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: playlistname,
              decoration:
                  const InputDecoration(label: Text('Name your playlist')),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                String? pickImage = await pickImageFile();
                setState(() {
                  imageUrl = pickImage;
                });
              },
              label: const Text('choose Image'),
              icon: const Icon(Icons.camera),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            createPlaylist();
            Navigator.pop(context);
          },
          label: const Text('save'),
          icon: const Icon(Icons.check),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          label: const Text('Cancel'),
          icon: const Icon(Icons.crop_square_sharp),
        )
      ],
    );
  }
}
