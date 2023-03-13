import 'package:flutter/material.dart';
import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';

class SinglePlantScreen extends StatefulWidget {
  const SinglePlantScreen({Key? key}) : super(key: key);

  @override
  State<SinglePlantScreen> createState() => _SinglePlantScreenState();
}

class _SinglePlantScreenState extends State<SinglePlantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: Text(
          'Your Plants',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
      ),
    );
  }
}
