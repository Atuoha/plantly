import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantly/presentation/entry.dart';
import 'package:plantly/resources/font_manager.dart';
import 'package:plantly/resources/route_manager.dart';
import 'package:plantly/resources/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/color.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const PlantApp());
}

class PlantApp extends StatelessWidget {
  const PlantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: bgLiteColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      theme: getLightTheme(),
      home: const EntryScreen(),
      routes: routes,
    );
  }
}
