import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantly/models/custom_error.dart';

import '../constants/firestore_refs.dart';
import '../models/task.dart';

class TaskRepository {
  final FirebaseFirestore firebaseFirestore;

  TaskRepository({required this.firebaseFirestore});

  Future addTask({required Task task}) async {
    try {
      FirestoreRef.todoRef.doc().set({
        'id': task.id,
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

  Future editTask({required Task task, required String id}) async {
    try {
      FirestoreRef.todoRef.doc(id).update({
        'id': task.id,
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
      FirestoreRef.todoRef.doc(id).delete();
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
