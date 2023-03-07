import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:google_sign_in/google_sign_in.dart';

import '../models/custom_error.dart';
import '../resources/string_manager.dart';

class AuthRepository {
  final FirebaseFirestore firebaseFirestore;
  final fbAuth.FirebaseAuth firebaseAuth;

  AuthRepository({required this.firebaseAuth, required this.firebaseFirestore});

  Stream<fbAuth.User?> get user => firebaseAuth.userChanges();

  // sign up
  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      fbAuth.UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await AppString.userDoc.doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'fullname': fullName,
        'email': email,
        'password': password,
        'profileImg':
            'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
        'auth_type': 'email/password'
      });
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
        errorMsg: e.toString(),
        code: 'Exception',
        plugin: 'Firebase/Exception',
      );
    }
  }

  // sign in
  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
        errorMsg: e.toString(),
        code: 'Exception',
        plugin: 'Firebase/Exception',
      );
    }
  }

  // google auth
  Future<void> googleAuth() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = fbAuth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final logCredentials =
          await firebaseAuth.signInWithCredential(credential);
      final user = logCredentials.user;

      AppString.userDoc.doc(user!.uid).set({
        'id': user.uid,
        'email': user.email,
        'fullname': user.displayName,
        'profileImg': user.photoURL,
        'auth_type': 'GoogleAuth',
      });
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(code: e.code, errorMsg: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        errorMsg: e.toString(),
        plugin: 'firebase_exception/server_error',
      );
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        errorMsg: e.toString(),
        plugin: 'firebase_exception/server_error',
      );
    }
  }

  // forgotPassword
}
