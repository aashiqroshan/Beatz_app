import 'package:beatz_musicplayer/pages/Homepage.dart';
import 'package:beatz_musicplayer/user_auth/firebase_authfunction.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController passagaincontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    passagaincontroller.dispose();
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
              TextField(
                controller: emailcontroller,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passcontroller,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextField(
                controller: passagaincontroller,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
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
    String email = emailcontroller.text;
    String password = passcontroller.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      print('user successfully created');
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else {
      print('some error occured');
    }
  }
  
}
