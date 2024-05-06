import 'package:beatz_musicplayer/models/playlist_provider.dart';
import 'package:beatz_musicplayer/pages/admin/admin_page.dart';
import 'package:beatz_musicplayer/pages/admin/upload_song.dart';
import 'package:beatz_musicplayer/pages/user/all_songs_page.dart';
import 'package:beatz_musicplayer/pages/loginss/splash.dart';
import 'package:beatz_musicplayer/pages/user/home_page.dart';
import 'package:beatz_musicplayer/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

const save_key = 'userloggedin';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => PlaylistProvider(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
