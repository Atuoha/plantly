// part of 'plant_bloc.dart';
//
// class PlantEvent extends Equatable {
//   const PlantEvent();
//
//   @override
//   List<Object?> get props => throw UnimplementedError();
// }
//
// class AddPlantEvent extends PlantEvent {
//   final Plant plant;
//   final ProcessStatus status;
//   final CustomError error;
//
//   const AddPlantEvent({
//     required this.plant,
//     required this.status,
//     required this.error,
//   });
//
//   @override
//   List<Object?> get props => [plant, status, error];
//
//   @override
//   String toString() {
//     return 'AddPlantEvent{plant: $plant,status:$status,error:$error}';
//   }
//
//   AddPlantEvent copyWith({
//     Plant? plant,
//     ProcessStatus? status,
//     CustomError? error,
//   }) {
//     return AddPlantEvent(
//       plant: plant ?? this.plant,
//       status: status ?? this.status,
//       error: error ?? this.error,
//     );
//   }
// }
//
// class EditPlantEvent extends PlantEvent {
//   final Plant plant;
//   final String id;
//   final ProcessStatus status;
//   final CustomError error;
//
//   const EditPlantEvent({
//     required this.plant,
//     required this.id,
//     required this.status,
//     required this.error,
//   });
//
//   @override
//   List<Object?> get props => [
//         plant,
//         id,
//         status,
//         error,
//       ];
//
//   @override
//   String toString() {
//     return 'EditPlantEvent{plant: $plant, id: $id,status:$status, error:$error}';
//   }
//
//   EditPlantEvent copyWith({
//     Plant? plant,
//     String? id,
//     ProcessStatus? status,
//     CustomError? error,
//   }) {
//     return EditPlantEvent(
//       plant: plant ?? this.plant,
//       id: id ?? this.id,
//       status: status ?? this.status,
//       error: error ?? this.error,
//     );
//   }
// }
//
// class DeletePlantEvent extends PlantEvent {
//   final String id;
//   final ProcessStatus status;
//   final CustomError error;
//
//   const DeletePlantEvent({
//     required this.id,
//     required this.status,
//     required this.error,
//   });
//
//   @override
//   List<Object?> get props => [id, status, error];
//
//   @override
//   String toString() {
//     return 'DeletePlantEvent{id: $id,status:$status,error:$error}';
//   }
//
//   DeletePlantEvent copyWith({
//     String? id,
//     ProcessStatus? status,
//     CustomError? error,
//   }) {
//     return DeletePlantEvent(
//       id: id ?? this.id,
//       status: status ?? this.status,
//       error: error ?? this.error,
//     );
//   }
// }
