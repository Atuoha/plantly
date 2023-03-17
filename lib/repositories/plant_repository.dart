import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plantly/models/custom_error.dart';

import '../constants/firestore_refs.dart';
import '../models/plant.dart';

class PlantRepository {
  final FirebaseFirestore firebaseFirestore;

  PlantRepository({required this.firebaseFirestore});

  Future uploadPlantImage() async {
    try {
      //  upload
    } on FirebaseException catch (e) {
      throw CustomError(errorMsg: e.message!, code: e.code, plugin: e.plugin);
    } on CustomError catch (e) {
      throw CustomError(
          errorMsg: e.code,
          code: 'Firebase Exemption',
          plugin: 'Firebase error/flutter');
    }
  }

  Future addPlant({required Plant plant}) async {
    try {
      FirestoreRef.plantRef.doc().set({
        'id': plant.id,
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

  Future editPlant({required Plant plant, required String id}) async {
    try {
      FirestoreRef.plantRef.doc(id).update({
        'id': plant.id,
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
      FirestoreRef.plantRef.doc(id).delete();
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
