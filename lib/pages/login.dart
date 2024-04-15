import 'package:beatz_musicplayer/pages/Homepage.dart';
import 'package:beatz_musicplayer/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 120,
            ),
            const Row(
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
                Spacer()
              ],
            ),
            const SizedBox(
              height: 70,
            ),
            Column(
              children: [
                TextField(
                  controller: emailcontroller,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passcontroller,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailcontroller.text,
                          password: passcontroller.text);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ));
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        foregroundColor: MaterialStatePropertyAll(Colors.white),
                        minimumSize: MaterialStatePropertyAll(Size(120, 50))),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 20),
                    )),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'OR',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('If you dont have one '),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUp(),
                      ));
                    },
                    style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    child: const Text(
                      'Create one',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}

// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:beatz/Login_screen.dart';

// Widget loginpage(BuildContext context) {

//   return
// }

