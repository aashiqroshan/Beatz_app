import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomPlaylistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPlaylist(String name) async {
    try {
      await _firestore
          .collection('playlists')
          .add({'name': name, 'songIds': []});
    } catch (e) {
      debugPrint('Error creating playlist: $e');
    }
  }

  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    try {
      DocumentReference playlistRef =
          _firestore.collection('playlists').doc(playlistId);
      await playlistRef.update({
        'songsIds': FieldValue.arrayUnion([songId])
      });
    } catch (e) {
      debugPrint('Error adding song to playlist: $e');
    }
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    try {
      DocumentReference playlistRef =
          _firestore.collection('playlists').doc(playlistId);
      await playlistRef.update({
        'songIds': FieldValue.arrayRemove([songId])
      });
    } catch (e) {
      debugPrint('Error removing song from playlist: $e');
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    try {
      await _firestore.collection('playlists').doc(playlistId).delete();
    } catch (e) {
      debugPrint('Error deleting playlist: $e');
    }
  }

  Stream<QuerySnapshot> getPlayist() {
    return _firestore.collection('playlists').snapshots();
  }

  Stream<DocumentSnapshot> getPlaylist(String playlistId) {
    return _firestore.collection('playlists').doc(playlistId).snapshots();
  }
}
