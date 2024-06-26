import 'package:beatz_musicplayer/components/styles.dart';
import 'package:beatz_musicplayer/pages/user/online/language_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LanguageList extends StatefulWidget {
  const LanguageList({super.key});

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  final Refactor refactor = Refactor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: refactor.appbartitles('Language list'),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Songs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final lanuages = snapshot.data!.docs
              .map((doc) => doc['language'] as String)
              .toSet()
              .toList();

          if (lanuages.isEmpty) {
            return const Center(
              child: Text('No language found'),
            );
          }

          return refactor.laglistviewbuilder(
            items: lanuages,
            pageReq: (languages) => LanguagePage(language: languages),
          );
        },
      ),
    );
  }
}
