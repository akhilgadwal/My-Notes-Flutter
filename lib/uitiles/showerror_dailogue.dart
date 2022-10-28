//12-22-22
//rewriting the code for error handeling errors
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Future<void> ShowErrorDail(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An Error as Occured'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}
