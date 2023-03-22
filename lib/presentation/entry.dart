import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:plantly/presentation/presentation_export.dart';
import '../business_logic/auth_bloc/auth_bloc.dart';
import '../constants/enums/auth_status.dart';
import 'utils/background_container.dart';
import '../resources/route_manager.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool isFirstRun = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          // checking first run
          bool ifr = await IsFirstRun.isFirstRun();
          if (ifr != null && !ifr) {
            setState(() {
              isFirstRun = false;
            });
          }
          if (isFirstRun) {
            Timer(
              const Duration(milliseconds: 3),
              () => Navigator.of(context).pushReplacementNamed(
                RouteManager.splashScreen,
              ),
            );
          } else {
            if (state.authStatus == AuthStatus.authenticated) {
              Timer(
                const Duration(milliseconds: 3),
                () => Navigator.of(context).pushReplacementNamed(
                  RouteManager.homeScreen,
                ),
              );
            } else {
              Timer(
                const Duration(milliseconds: 3),
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(signIn: false),
                  ),
                ),
              );
            }
          }
        },
        child: BackgroundContainer(
          begin: Alignment.topCenter,
          stops: const [0.1, 1.0],
          child: Center(
            child: Image.asset('assets/images/app_name.png'),
          ),
        ),
      ),
    );
  }
}
