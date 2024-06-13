import 'package:hive/hive.dart';
import 'song.dart';

part 'offline_playlist_model.g.dart';

@HiveType(typeId: 2)
class Playlist extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Song> songs;

  Playlist({required this.name, required this.songs});
}
