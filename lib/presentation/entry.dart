import 'dart:async';

import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
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
  @override
  void initState() {
    _startRun();
    super.initState();
  }

  _startRun() async {
    bool ifr = await IsFirstRun.isFirstRun();
    var duration = const Duration(seconds: 3);
    if (ifr != null && !ifr) {
      // Timer(duration, _navigateToHomeOrAuth);
      Timer(duration, _navigateToOnBoarding);

    } else {
      Timer(duration, _navigateToOnBoarding);
    }
  }

  void _navigateToHomeOrAuth() {
    Navigator.of(context).pushReplacementNamed(RouteManager.homeScreen);
  }

  void _navigateToOnBoarding() {
    Navigator.of(context).pushReplacementNamed(RouteManager.splashScreen);
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
