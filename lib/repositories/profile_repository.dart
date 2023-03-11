import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import '../constants/firestore_refs.dart';
import '../models/custom_error.dart';
import '../models/user.dart';

class ProfileRepository {
  final fbauth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  ProfileRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
  });

  // Fetch User
  Future<User> fetchUser({required String userId}) async {
    try {
      final DocumentSnapshot userDoc =
          await FirestoreRef.userRef.doc(userId).get();
      if (userDoc.exists) {
        final currentUser = User.fromDoc(userDoc);
        return currentUser;
      }
      throw 'User not found';
    } on FirebaseException catch (e) {
      print('Hello there is an error from Profile Repo');
      print(e);
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);

    }
  }

  // Edit User
  Future<void> editUser({
    required String userId,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await FirestoreRef.userRef.doc(userId).update({
        'email': email,
        'fullname': fullName,
      });
      await firebaseAuth.currentUser!.updateEmail(email);
      await firebaseAuth.currentUser!.updatePassword(password);
    } on FirebaseException catch (e) {
      throw CustomError(
        errorMsg: e.message!,
        code: e.code,
        plugin: e.plugin,
      );
    }
  }

  // Update Profile Image
  Future<void> updateProfileImage() async {
    // handle profile image update
  }
}
