import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/uitiles/showerror_dailogue.dart';
import 'package:mynotes/verification_email.dart';
import 'dart:developer' as devtools show log;
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
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final User = FirebaseAuth.instance.currentUser;
                await User?.sendEmailVerification();
                Navigator.of(context).pushNamed(VerifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  await ShowErrorDail(
                    context,
                    'Weak Password',
                  );
                } else if (e.code == 'email-already-in-use') {
                  await ShowErrorDail(
                    context,
                    'Email already used',
                  );
                } else if (e.code == 'invalid-email') {
                  await ShowErrorDail(
                    context,
                    'Invalid Email',
                  );
                } else {
                  await ShowErrorDail(
                    context,
                    'Error: ${e.code}',
                  );
                }
              } catch (e) {
                await ShowErrorDail(
                  context,
                  e.toString(),
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(LoginRoute, (route) => false);
              },
              child: Text('Already Register? Login!'))
        ],
      ),
    );
  }
}
