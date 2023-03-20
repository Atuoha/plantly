import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<Plant> fetchSinglePlant({required String id}) async {
    try {
      final DocumentSnapshot plantDoc =
          await FirestoreRef.plantRef.doc(id.trim()).get();
      if (plantDoc.exists) {
        final plant = Plant.fromJson(plantDoc);
        print(plant.imgUrl);
        return plant;
      }
      throw 'Plant not found!';
    } on FirebaseException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
          errorMsg: e.code,
          code: 'Firebase Exemption',
          plugin: 'Firebase error/flutter');
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
          plugin: 'Firebase error/flutter');
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
          plugin: 'Firebase error/flutter');
    }
  }
}
