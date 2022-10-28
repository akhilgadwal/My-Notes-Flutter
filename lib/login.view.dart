import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constant/routes.dart';
import 'uitiles/showerror_dailogue.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //dispose
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            decoration: const InputDecoration(
              hintText: 'Enter Email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            decoration: const InputDecoration(hintText: 'Enter Password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              //creating log in with email and passwords
              //try catch blocs
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final User = FirebaseAuth.instance.currentUser;
                if (User?.emailVerified ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(NotesRoute, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      VerifyEmailRoute, (route) => false);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  await ShowErrorDail(
                    context,
                    'User not found',
                  );
                } else if (e.code == 'wrong-password') {
                  await ShowErrorDail(
                    context,
                    'Wrong Password',
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
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(RegisterRoute, (route) => false);
              },
              child: const Text('Register Now for first time'))
        ],
      ),
    );
  }
}
