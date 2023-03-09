import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import '../../models/custom_error.dart';
import '../../models/success.dart';


void successDialog({required BuildContext context, required Success success}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title:  Text(success.title),
        content: Text(success.description),
        actions: [
          CupertinoDialogAction(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title:  Text(success.title),
          content: Text(success.description),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Dismiss'),
            ),
          ]),
    );
  }
}
