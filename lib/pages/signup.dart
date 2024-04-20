import 'package:beatz_musicplayer/models/firebase_auth_services.dart';
import 'package:beatz_musicplayer/pages/Homepage.dart';
import 'package:beatz_musicplayer/models/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController usercontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    usercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser;

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
                    'Sign up',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
                  ),
                  Spacer()
                ],
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usercontroller,
                        decoration: const InputDecoration(labelText: 'User'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter your username';
                          }
                          return null;
                        },
                      ),
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
                      TextFormField(
                        controller: passcontroller,
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter your password';
                          }

                          return null;
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Text(
                'By pressing sign up you agree all T&C',
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: signUp,
                  style: const ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(120, 50)),
                      backgroundColor: MaterialStatePropertyAll(Colors.black),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: const Text('Sign up')),
              const Text(
                'OR',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const Text('If you already have an account '),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(Colors.black)),
                child: const Text('Login to your account'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      String username = usercontroller.text;
      String email = emailcontroller.text;
      String password = passcontroller.text;

      User? user = await _auth.signUpWithEmailPassword(email, password);

      if (user != null) {
        print('user successfully created');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating user. please try again')));
      }
    }
  }
}
