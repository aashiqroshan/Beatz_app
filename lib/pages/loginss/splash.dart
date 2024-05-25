import 'package:beatz_musicplayer/main.dart';
import 'package:beatz_musicplayer/pages/loginss/login.dart';
import 'package:beatz_musicplayer/pages/user/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkloggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: const Image(
            image: AssetImage('assets/images/cassette.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.8),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Beatz',
                style: TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
              const Text(
                'Feel the Beatz',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(
                height: 70,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                  style: ButtonStyle(
                      minimumSize:
                          const MaterialStatePropertyAll(Size(120, 50)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStatePropertyAll(
                          Colors.black.withOpacity(0.3)),
                      foregroundColor:
                          const MaterialStatePropertyAll(Colors.white)),
                  child: const Text('Get started'),
                ),
              )
            ],
          ),
        )
      ])),
    );
  }

  Future<void> checkloggedIn() async {
    final sharedprefs = await SharedPreferences.getInstance();
    final bool? userloggedin = sharedprefs.getBool('user_logged_in');
    if (userloggedin == null || userloggedin ) {
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    }
  }
}
