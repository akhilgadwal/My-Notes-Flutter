import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/login.view.dart';

import 'Register_view.dart';
import 'constant/routes.dart';

///for verifiying email ///
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verification')),
      body: Column(children: [
        const Text(
            'Email has been sent if not received press below given link'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          },
          child: const Text(
            'Email Verification',
          ),
        ),
        TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                RegisterRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'))
      ]),
    );
  }
}
