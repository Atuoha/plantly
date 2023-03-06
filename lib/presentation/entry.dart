import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_widget/main.dart';
import 'utils/background_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color.dart';
import '../resources/route_manager.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool? isFirstRun;

  @override
  void initState() {
    loadingAction();
    super.initState();
  }

  void loadingAction() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isFirstRun =  prefs.getBool('isFirstRun');
    if (!isFirstRun!) {
      print('APP RAN BEFORE');
      Timer(
          const Duration(seconds: 5),
          () => Navigator.of(context)
              .pushReplacementNamed(RouteManager.homeScreen));
    } else {
      print('APP NOT RAN BEFORE');
      Timer(
          const Duration(seconds: 5),
          () => Navigator.of(context)
              .pushReplacementNamed(RouteManager.splashScreen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundContainer(
        begin: Alignment.topCenter,
        stops: const [0.1, 1.0],
        child: Center(
          child: Image.asset('assets/images/app_name.png'),
        ),
      ),
    );
  }
}
