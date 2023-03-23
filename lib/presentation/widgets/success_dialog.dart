import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import '../../constants/color.dart';
import '../../models/custom_error.dart';
import '../../models/success.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

void successDialog({required BuildContext context, required Success success}) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(
          success.title,
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s16,
          ),
        ),
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
        title: Text(
          success.title,
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s16,
          ),
        ),
        content: Text(success.description),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }
}
