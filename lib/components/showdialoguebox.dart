import 'dart:io';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AddSongBox extends StatefulWidget {
  const AddSongBox({super.key});

  @override
  State<AddSongBox> createState() => _AddSongBoxState();
}

class _AddSongBoxState extends State<AddSongBox> {
  TextEditingController titleController = TextEditingController();
  TextEditingController artistController = TextEditingController();
  String? imageurl;
  String? audiourl;

  Future<void> saveSong({
    required String songName,
    required String artistName,
    required String? imagepath,
    required String? audiopath,
  }) async {
    if (songName.isEmpty) {
      debugPrint('Song name is empty');
    } else if (artistName.isEmpty) {
      debugPrint('Artist name is empty');
    } else if (imagepath == null) {
      debugPrint('Image path is null');
    } else if (audiopath == null) {
      debugPrint('Audio path is null');
    } else {
      final song = Song(
        songName: songName,
        artistName: artistName,
        albumArtImagePath: imagepath,
        audioPath: audiopath,
      );

      final box = Hive.box<Song>('Box');
      await box.add(song);
      debugPrint('The song is saved');
      Navigator.pop(context);
    }
  }

  Future<String?> pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    return result?.files.single.path;
  }

  Future<String?> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    return result?.files.single.path;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Song'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: GestureDetector(
                onTap: () async {
                  String? pickedImage = await pickImageFile();
                  setState(() {
                    imageurl = pickedImage;
                  });
                  if (pickedImage != null) {
                    debugPrint('Image is picked');
                  }
                },
                child: imageurl != null
                    ? ClipOval(
                        child: Image.file(
                          File(imageurl!),
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                        ),
                      )
                    : const Icon(Icons.add_a_photo),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Song Name'),
            ),
            TextField(
              controller: artistController,
              decoration: const InputDecoration(labelText: 'Artist Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? audioFilePath = await pickAudioFile();
                setState(() {
                  audiourl = audioFilePath;
                });
                if (audioFilePath != null) {
                  debugPrint('Audio is selected');
                }
              },
              child: const Text('Select Audio'),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                saveSong(
                  songName: titleController.text,
                  artistName: artistController.text,
                  imagepath: imageurl,
                  audiopath: audiourl,
                );
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
