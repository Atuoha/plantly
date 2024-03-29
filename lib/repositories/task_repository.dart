import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantly/models/custom_error.dart';
import '../constants/firestore_refs.dart';
import '../models/task.dart';

class TaskRepository {
  final FirebaseFirestore firebaseFirestore;

  TaskRepository({required this.firebaseFirestore});

  Future addTask({required Task task}) async {
    try {
      await FirestoreRef.taskRef.doc().set({
        'id': task.id,
        'userId': task.userId,
        'title': task.title,
        'description': task.description,
        'plantId': task.plantId,
        'date': task.date,
        'repeat': task.repeat,
      });
    } on FirebaseException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
          errorMsg: e.code,
          code: 'Firebase Exemption',
          plugin: 'Firebase error/flutter');
    }
  }

  Future<List<Task>> fetchTasks() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final Query query = FirestoreRef.taskRef.where('userId', isEqualTo: userId);

    try {
      final QuerySnapshot querySnapshot = await query.get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Task> tasks = [];
      for (var document in documents) {
        var task = Task.fromJson(document);
        tasks.add(task);
      }
      return tasks;
    } on FirebaseException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
        errorMsg: e.code,
        code: 'Firebase Exemption',
        plugin: 'Firebase error/flutter',
      );
    }
  }

  Future editTask({required Task task, required String id}) async {
    try {
      await FirestoreRef.taskRef.doc(id).update({
        'id': task.id,
        'userId': task.userId,
        'title': task.title,
        'description': task.description,
        'plantId': task.plantId,
        'date': task.date,
        'repeat': task.repeat,
      });
    } on FirebaseException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
          errorMsg: e.code,
          code: 'Firebase Exemption',
          plugin: 'Firebase error/flutter');
    }
  }

  Future deleteTask({required String id}) async {
    try {
      await FirestoreRef.taskRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
          errorMsg: e.code,
          code: 'Firebase Exemption',
          plugin: 'Firebase error/flutter');
    }
  }
}
