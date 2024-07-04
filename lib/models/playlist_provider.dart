import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class PlaylistProvider extends ChangeNotifier {
  late final Box<Song> _songBox;
  late final Box<String> _favoriteBox;

  final List<Song> _playlist = [];

  int? _currentSongIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlaylistProvider() {
    _init();
    listenToDuration();
  }

  bool _isPlaying = false;

  void _init() async {
    _songBox = Hive.box<Song>('Box');
    _favoriteBox = Hive.box<String>('favBox');
    _playlist.addAll(_songBox.values.toList());
    notifyListeners();
  }

  void play() async {
    if (_currentSongIndex != null) {
      final String path = _playlist[_currentSongIndex!].audioPath;
      debugPrint('Playing song from path: $path');
      await _audioPlayer.stop();
      await _audioPlayer.play(DeviceFileSource(path));
      _isPlaying = true;
      notifyListeners();
    }
  }

  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void playNextSong() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  void listenToDuration() async {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
    _audioPlayer.onPositionChanged.listen((newDuration) {
      _currentDuration = newDuration;
      notifyListeners();
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  void toggleFavorite(String songName) {
    if (_favoriteBox.containsKey(songName)) {
      _favoriteBox.delete(songName);
    } else {
      _favoriteBox.put(songName, songName);
    }
    notifyListeners();
  }

  bool isFavorite(String songName) {
    return _favoriteBox.containsKey(songName);
  }

  Future<List<Song>> getAllSongs() async {
    final List<Song> songs = _songBox.values.cast<Song>().toList();
    return songs;
  }

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }
}
