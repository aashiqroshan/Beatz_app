import 'package:beatz_musicplayer/models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseAuthService() {
    _auth.setPersistence(Persistence.LOCAL);
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      debugPrint('some error occured in $e');
    }
    return null;
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      debugPrint('some error occured');
    }
    return null;
  }

  // Stream<List<Song>> getSongs() {
  //   return _firestore.collection('songs').snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => Song.fromMap(doc.data() as Map<String, dynamic>)).toList());
  // }
}
