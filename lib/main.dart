import 'package:beatz_musicplayer/components/bottm_navigator.dart';
import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:beatz_musicplayer/models/song.dart';
import 'package:beatz_musicplayer/pages/admin/admin_page.dart';
import 'package:beatz_musicplayer/pages/loginss/splash.dart';
import 'package:beatz_musicplayer/pages/user/home_page.dart';
import 'package:beatz_musicplayer/pages/user/online_playlist.dart';
import 'package:beatz_musicplayer/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapter());
  await Hive.openBox<Song>('Box');
  await Hive.openBox<String>('favBox');
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      title: 'Beatz Music Player',
      home: const BottomNavi(),
    );
  }
}
