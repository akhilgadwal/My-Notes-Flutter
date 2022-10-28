import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/login.view.dart';
import 'package:mynotes/verification_email.dart';
import 'dart:developer' as devtools show log;

import 'Register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      routes: {
        LoginRoute: (context) => const Loginpage(),
        RegisterRoute: (context) => const Register(),
        //creating new route date is 21-10-2022
        NotesRoute: (context) => const Notesview(),
        //creatinf new routes
        VerifyEmailRoute: ((context) => const VerifyEmailView())
      },
    ),
  );
}
//creating staless widget home for trying to make 1 time intliazing firebase

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const Notesview();
                print('Email verified');
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const Loginpage();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

//Notesview new cls the main ui for it log out also
//yelikha gaya hia 10/20/22 ko
enum MenuAction { logout }

class Notesview extends StatefulWidget {
  const Notesview({super.key});

  @override
  State<Notesview> createState() => _NotesviewState();
}

class _NotesviewState extends State<Notesview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await ShowDailogueBox(context);
                  if (shouldlogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context) //now
                        .pushNamedAndRemoveUntil(LoginRoute, (_) => false);
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log Out'),
                )
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}

Future<bool> ShowDailogueBox(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure u want to LogOut'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
