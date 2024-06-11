import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all favorite song IDs
  Future<List<Map<String, dynamic>>> fetchFavSongs() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('favorites').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
    } catch (e) {
      debugPrint('Error fetching favorite songs: $e');
      return [];
    }
  }

  // Add a song to favorites
  Future<void> addTofav(Map<String, dynamic> songData) async {
    try {
      await _firestore
          .collection('favorites')
          .doc(songData['id'])
          .set(songData);
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
    }
  }

  // Remove a song from favorites
  Future<void> removeFromFav(String songId) async {
    try {
      await _firestore.collection('favorites').doc(songId).delete();
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }
}
