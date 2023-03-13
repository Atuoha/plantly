import 'package:flutter/material.dart';
import 'package:plantly/resources/styles_manager.dart';

import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s20,
          ),
        ),
      ),
    );
  }
}
