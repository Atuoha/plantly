import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import '../../models/custom_error.dart';


void errorDialog({required BuildContext context, required CustomError error}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title:  Text(error.code),
        content: Text('${error.plugin}\n${error.errorMsg}'),
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
          title:  Text(error.code),
          content: Text('${error.plugin}\n${error.errorMsg}'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:const  EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Dismiss'),
            ),
          ]),
    );
  }
}
