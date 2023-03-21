import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Plant extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imgUrl;
  final int waterLevel;
  final int sunLevel;
  final String userId;

  const Plant({
    required this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.waterLevel,
    required this.sunLevel,
    required this.userId,
  });

  factory Plant.initial() => const Plant(
        id: '',
        title: '',
        description: '',
        imgUrl: '',
        waterLevel: 0,
        sunLevel: 0,
        userId: '',
      );

  factory Plant.fromJson(DocumentSnapshot plantDoc) {
    var plant = plantDoc.data() as Map<String, dynamic>;

    return Plant(
      id: plant['id'],
      title: plant['title'],
      description: plant['description'],
      imgUrl: plant['imgUrl'],
      waterLevel: plant['waterLevel'],
      sunLevel: plant['sunLevel'],
      userId: plant['userId'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imgUrl,
        waterLevel,
        sunLevel,
        userId,
      ];

  @override
  String toString() {
    return 'Plant{id: $id, title: $title, description: $description, imgUrl: $imgUrl, waterLevel: $waterLevel, sunLevel: $sunLevel,userId:$userId}';
  }

  Plant copyWith({
    String? id,
    String? title,
    String? description,
    String? imgUrl,
    int? waterLevel,
    int? sunLevel,
    String? userId,
  }) {
    return Plant(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
      waterLevel: waterLevel ?? this.waterLevel,
      sunLevel: sunLevel ?? this.sunLevel,
      userId: userId ?? this.userId,
    );
  }
}
