import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantly/presentation/entry.dart';
import 'package:plantly/resources/route_manager.dart';

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
    return MaterialApp(home: const EntryScreen(), routes: routes);
  }
}
