import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> fetchFavSongs() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userdoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userdoc.exists) {
        return List<String>.from(userdoc.get('favorites') ?? []);
      } else {
        debugPrint('the userdoc doesnt exsist');
        return [];
      }
    }
    return [];
  }

  Future<void> addTofav(String songId) async {
    final User? user = _auth.currentUser;
    debugPrint('its trying to add');
    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        await userDocRef.update({
          'favorites': FieldValue.arrayUnion([songId])
        });
      } else {
        await userDocRef.set({
          'favorites': [songId]
        });
      }
    }
  }

  Future<void> removeFromFav(String songId) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final userDocref = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot userDoc = await userDocref.get();

      if (userDoc.exists) {
        debugPrint('userDoc exsist in removefav');
        await userDocref.update({'favorites': FieldValue.arrayRemove([songId])});
      }
    }
  }

  Future<void> toggleFav(String songId) async {
    final List<String> favsongs = await fetchFavSongs();
    if (favsongs.contains(songId)) {
      await removeFromFav(songId);
    } else {
      await addTofav(songId);
    }
  }
}
