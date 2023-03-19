import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/enums/process_status.dart';
import '../../models/custom_error.dart';
import '../../models/plant.dart';
import '../../repositories/plant_repository.dart';

part 'plant_state.dart';

class PlantCubit extends Cubit<PlantState> {
  final PlantRepository plantRepository;

  PlantCubit({required this.plantRepository}) : super(PlantState.initial());

  Future<void> addPlant({required Plant plant}) async {
    emit(state.copyWith(status: ProcessStatus.loading));

    try {
      await plantRepository.addPlant(plant: plant);
      emit(state.copyWith(
        plant: plant,
        status: ProcessStatus.success,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: ProcessStatus.error,
        error: e,
      ));
    }
  }

  Future<void> editPlant({
    required Plant plant,
    required String id,
  }) async {
    emit(state.copyWith(status: ProcessStatus.loading));

    try {
      await plantRepository.editPlant(plant: plant, id: id);
      emit(state.copyWith(
        plant: plant,
        status: ProcessStatus.success,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: ProcessStatus.error,
        error: e,
      ));
    }

    Future<void> deletePlant({required String id}) async {
      emit(state.copyWith(status: ProcessStatus.loading));
      try {
        await  plantRepository.deletePlant(id: id);
        emit(state.copyWith(
          status: ProcessStatus.success,
        ));
      } on CustomError catch (e) {
        emit(state.copyWith(
          status: ProcessStatus.error,
          error: e,
        ));
      }
    }
  }
}
