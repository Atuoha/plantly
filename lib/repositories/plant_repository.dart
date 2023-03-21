import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plantly/models/custom_error.dart';

import '../constants/firestore_refs.dart';
import '../models/plant.dart';

class PlantRepository {
  final FirebaseFirestore firebaseFirestore;

  PlantRepository({required this.firebaseFirestore});

  Future addPlant({required Plant plant}) async {
    try {
      await FirestoreRef.plantRef.doc().set({
        'id': plant.id,
        'userId': plant.userId,
        'title': plant.title,
        'description': plant.description,
        'imgUrl': plant.imgUrl,
        'waterLevel': plant.waterLevel,
        'sunLevel': plant.sunLevel,
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

  Future<List<Plant>> fetchPlants() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final Query query = FirestoreRef.plantRef.where('userId', isEqualTo: userId);

    try {
      final QuerySnapshot querySnapshot = await query.get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;
      List<Plant> plants = [];
      for (var document in documents) {
        var plant = Plant.fromJson(document);
        plants.add(plant);
      }
      return plants;
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

  Future<int> fetchTask({required String plantId}) async {
    final Query query =
        FirestoreRef.taskRef.where('plantId', isEqualTo: plantId.trim());

    try {
      final QuerySnapshot querySnapshot = await query.get();
      final List<DocumentSnapshot> document = querySnapshot.docs;
      final taskLength = document.length;
      return taskLength;
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

  Future<Plant> fetchSinglePlant({required String id}) async {
    final Query query = FirestoreRef.plantRef.where('id', isEqualTo: id.trim());
    try {
      final QuerySnapshot querySnapshot = await query.get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;
      Plant plant = Plant.initial();
      for (var document in documents) {
        plant = Plant.fromJson(document);
      }
      return plant;
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

  Future editPlant({required Plant plant, required String id}) async {
    try {
      await FirestoreRef.plantRef.doc(id).update({
        'id': plant.id,
        'userId': plant.userId,
        'title': plant.title,
        'description': plant.description,
        'imgUrl': plant.description,
        'waterLevel': plant.waterLevel,
        'sunLevel': plant.sunLevel,
      });
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

  Future deletePlant({required String id}) async {
    try {
      await FirestoreRef.plantRef.doc(id).delete();
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
}
