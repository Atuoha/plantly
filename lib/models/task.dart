import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String plantId;
  final DateTime date;
  final String repeat;
  final String userId;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.plantId,
    required this.date,
    required this.repeat,
    required this.userId,
  });

  factory Task.initial() => Task(
        id: '',
        title: '',
        description: '',
        plantId: '',
        date: DateTime.now(),
        repeat: '',
        userId: '',
      );

  factory Task.fromJson(DocumentSnapshot taskDoc) {
    final task = taskDoc.data() as Map<String, dynamic>;

    return Task(
      id: task['id'],
      title: task['title'],
      description: task['description'],
      plantId: task['plantId'],
      date: task['date'].toDate(),
      repeat: task['repeat'],
      userId: task['userId'],
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, plantId, date, repeat, userId];

  @override
  String toString() {
    return 'Task{id: $id, title: $title, description: $description, plantId: $plantId, date: $date, repeat: $repeat,userId:$userId}';
  }
}
