import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:plantly/presentation/presentation_export.dart';
import '../business_logic/auth_bloc/auth_bloc.dart';
import '../constants/enums/auth_status.dart';
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
      Timer(duration, _navigateToHomeOrAuth);
    } else {
      Timer(duration, _navigateToOnBoarding);
    }
  }

  void _navigateToHomeOrAuth() {
    BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.authenticated) {
          print('authenticated');
          Navigator.of(context).pushReplacementNamed(RouteManager.homeScreen);
        } else {
          print('unauthenticated');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AuthScreen(signIn: false),
            ),
          );
        }
      },
    );
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
