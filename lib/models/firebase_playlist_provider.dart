import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebasePlaylistProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _FirebasePlaylist = [];
  int? _currentSongIndex;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  Map<String, dynamic>? currentSong;
  int currentIndex = 0;
  bool _isShuffle = false;
  bool _isRepeat = false;

  FirebasePlaylistProvider() {
    fetchFirebaseSongs();
    listenToDuration();
  }

  void setPlaylist(List<Map<String, dynamic>> playlist, int songIndex) {
    _FirebasePlaylist = playlist;
    _currentSongIndex = songIndex;
    _playCurrentSong();
  }

  void _playCurrentSong() {
    if (_currentSongIndex != null) {
      final currentSong = _FirebasePlaylist[_currentSongIndex!];
      _audioPlayer.play(UrlSource(currentSong['audioUrl']));
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> fetchFirebaseSongs() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('Songs').get();
    final firebaseSongs = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'],
        'artist': data['artist'],
        'imageUrl': data['imageUrl'],
        'audioUrl': data['audioUrl']
      };
    }).toList();
    _FirebasePlaylist.addAll(firebaseSongs);
    notifyListeners();
  }

  void playSong(Map<String, dynamic> song, int index) async {
    currentSong = song;
    currentIndex = index;
    await _audioPlayer.play(UrlSource(song['audioUrl']));
    _isPlaying = true;
    notifyListeners();
  }

  void play(int songIndex) async {
    if (songIndex != null) {
      _currentSongIndex = songIndex;
      final Map<String, dynamic> song = _FirebasePlaylist[songIndex];
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(song['audioUrl']));
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

  List<Map<String, dynamic>> get playlist => _FirebasePlaylist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  void listenToDuration() {
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

  void playNextSong() {
    if (_isShuffle) {
      currentIndex =
          (currentIndex + Random().nextInt(_FirebasePlaylist.length)) %
              _FirebasePlaylist.length;
    } else {
      currentIndex = (_currentSongIndex! + 1) % _FirebasePlaylist.length;
    }
    play(currentIndex);
  }

  void playPreviousSong() async {
    if (_currentDuration.inSeconds > 2) {
      _audioPlayer.seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        _currentSongIndex = _currentSongIndex! - 1;
      } else {
        _currentSongIndex = _FirebasePlaylist.length - 1;
      }
      play(_currentSongIndex!);
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }
}
