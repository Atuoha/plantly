// import 'dart:async';
// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
//
// import '../../constants/enums/process_status.dart';
// import '../../models/custom_error.dart';
// import '../../models/plant.dart';
// import '../../repositories/plant_repository.dart';
//
// part 'plant_event.dart';
//
// part 'plant_state.dart';
//
// class PlantBloc extends Bloc<PlantEvent, PlantState> {
//   final PlantRepository plantRepository;
//
//   PlantBloc({required this.plantRepository}) : super(PlantState.initial()) {
//     on<AddPlantEvent>((event, emit) {
//       emit(state.copyWith(
//         status: event.status,
//         plant: event.plant,
//         error: event.error,
//       ));
//     });
//
//     Future<void> addPlant({required Plant plant}) async {
//       add(AddPlantEvent(
//         plant: Plant.initial(),
//         status: ProcessStatus.loading,
//         error: CustomError.initial(),
//       ));
//
//       try {
//         plantRepository.addPlant(plant: plant);
//         add(AddPlantEvent(
//           plant: plant,
//           status: ProcessStatus.success,
//           error: CustomError.initial(),
//         ));
//       } on CustomError catch (e) {
//         add(AddPlantEvent(
//           plant: Plant.initial(),
//           status: ProcessStatus.error,
//           error: e,
//         ));
//       }
//     }
//
//     on<EditPlantEvent>((event, emit) {
//       emit(state.copyWith(
//         status: event.status,
//         plant: event.plant,
//         error: event.error,
//       ));
//     });
//
//     Future<void> editPlant({
//       required Plant plant,
//       required String id,
//     }) async {
//       add(EditPlantEvent(
//         plant: Plant.initial(),
//         id: id,
//         status: ProcessStatus.loading,
//         error: CustomError.initial(),
//       ));
//
//       try {
//         plantRepository.editPlant(plant: plant, id: id);
//         add(EditPlantEvent(
//           plant: plant,
//           id: id,
//           status: ProcessStatus.success,
//           error: CustomError.initial(),
//         ));
//       } on CustomError catch (e) {
//         add(EditPlantEvent(
//           plant: Plant.initial(),
//           id: id,
//           status: ProcessStatus.error,
//           error: e,
//         ));
//       }
//     }
//
//     on<DeletePlantEvent>((event, emit) {
//       emit(state.copyWith(status: ProcessStatus.success));
//     });
//
//     Future<void> deletePlant({required String id}) async {
//       add(DeletePlantEvent(
//         id: id,
//         status: ProcessStatus.loading,
//         error: CustomError.initial(),
//       ));
//
//       try {
//         plantRepository.deletePlant(id: id);
//         add(DeletePlantEvent(
//           id: id,
//           status: ProcessStatus.success,
//           error: CustomError.initial(),
//         ));
//       } on CustomError catch (e) {
//         add(DeletePlantEvent(
//           id: id,
//           status: ProcessStatus.error,
//           error: e,
//         ));
//       }
//     }
//   }
// }
