import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Plant extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imgUrl;
  final double waterLevel;
  final double sunLevel;

  const Plant({
    required this.id,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.waterLevel,
    required this.sunLevel,
  });

  factory Plant.initial() => const Plant(
        id: '',
        title: '',
        description: '',
        imgUrl: '',
        waterLevel: 0,
        sunLevel: 0,
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
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, imgUrl, waterLevel, sunLevel];

  @override
  String toString() {
    return 'Plant{id: $id, title: $title, description: $description, imgUrl: $imgUrl, waterLevel: $waterLevel, sunLevel: $sunLevel}';
  }

  Plant copyWith({
    String? id,
    String? title,
    String? description,
    String? imgUrl,
    double? waterLevel,
    double? sunLevel,
  }) {
    return Plant(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
      waterLevel: waterLevel ?? this.waterLevel,
      sunLevel: sunLevel ?? this.sunLevel,
    );
  }
}
