import 'package:beatz_musicplayer/pages/user/home_page.dart';
import 'package:beatz_musicplayer/pages/admin/admin_page.dart';
import 'package:beatz_musicplayer/pages/loginss/signup.dart';
import 'package:beatz_musicplayer/models/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    super.dispose();
  }

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
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailcontroller,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please enter your email';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passcontroller,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      signIn();
                      passcontroller.clear();
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const SignUp(),
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

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      String email = emailcontroller.text;
      String password = passcontroller.text;

      if (email == 'admin@gmail.com' && password == 'admin123') {
        print('admin has logged in');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const AdminHomePage(),
        ));
      } else {
        User? user = await _auth.signInWithEmailPassword(email, password);

        if (user != null) {
          // final SharedPreferences sharePrefs =
          //     await SharedPreferences.getInstance();
          // sharePrefs.setBool('user_logged_in', true);
          print('user successfully signed in');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error logging in. please try again')));
        }
      }
    }
  }
}
