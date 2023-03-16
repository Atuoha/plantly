import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRef {
  static var userRef = FirebaseFirestore.instance.collection('user');
  static var plantRef = FirebaseFirestore.instance.collection('plant');
  static var todoRef = FirebaseFirestore.instance.collection('todo');
}
