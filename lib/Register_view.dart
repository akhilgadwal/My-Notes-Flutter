import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Texting Editing controller creating
  late final TextEditingController _email;
  late final TextEditingController _passwords;

//creating init
  @override
  void initState() {
    _email = TextEditingController();
    _passwords = TextEditingController();
    super.initState();
  }

//disposing it
  @override
  void dispose() {
    _email.dispose();
    _passwords.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   //Adding aap bar to it
    //   appBar: AppBar(
    //     title: const Text('Register'),
    //   ),
    //   body: FutureBuilder(
    //     future: Firebase.initializeApp(
    //         options: DefaultFirebaseOptions.currentPlatform),
    //     builder: (context, snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           return ;
    //         default:
    //           return Text('Loading...');
    //       }
    //     },
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            //assiging controllers
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          TextField(
            controller: _passwords,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          TextButton(
            onPressed: () async {
              //
              final email = _email.text;
              final password = _passwords.text;
              //creating users and firebaseauth
              try {
                final UserCredential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email, password: password);
                print(UserCredential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('weak Password');
                } else if (e.code == 'email-already-in-use') {
                  print('Email already in used');
                } else if (e.code == 'invalid-email') {
                  print('Invalid Email');
                }
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (route) => false);
              },
              child: Text('Already Register? Login!'))
        ],
      ),
    );
  }
}
