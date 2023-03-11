import 'package:flutter/material.dart';
import 'package:plantly/constants/color.dart';

import '../../constants/enums/status.dart';
import '../../resources/styles_manager.dart';

void displaySnackBar(
    {required Status status,
    required String message,
    required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: status == Status.success ? primaryColor : Colors.red,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: getRegularStyle(color: Colors.white),
          ),
          Image.asset(
            status == Status.success
                ? 'assets/images/love.png'
                : 'assets/images/angry.png',
            width: 30,
          )
        ],
      ),
    ),
  );
}
