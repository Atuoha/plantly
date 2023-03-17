import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantly/business_logic/exports.dart';
import 'package:plantly/presentation/entry.dart';
import 'package:plantly/repositories/auth_repository.dart';
import 'package:plantly/repositories/plant_repository.dart';
import 'package:plantly/repositories/profile_repository.dart';
import 'package:plantly/resources/font_manager.dart';
import 'package:plantly/resources/route_manager.dart';
import 'package:plantly/resources/theme_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/color.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepository(
            firebaseAuth: FirebaseAuth.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider(
          create: (context) => PlantRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignInCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SignUpCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => GoogleAuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ProfileCubit(
              profileRepository: context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PlantCubit(
              plantRepository: context.read<PlantRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: getLightTheme(),
          home: const EntryScreen(),
          routes: routes,
        ),
      ),
    );
  }
}
