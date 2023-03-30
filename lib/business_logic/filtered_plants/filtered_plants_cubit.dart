import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../constants/enums/plant_filter.dart';
import '../../constants/enums/process_status.dart';
import '../../models/plant.dart';

part 'filtered_plants_state.dart';

class FilteredPlantsCubit extends Cubit<FilteredPlantsState> {
  final List<Plant> plants;

  FilteredPlantsCubit({required this.plants})
      : super(
          FilteredPlantsState(
            plants: plants,
            status: ProcessStatus.success,
          ),
        );

  void setPlants(List<Plant> plants) {
    emit(
      state.copyWith(
        plants: plants,
        status: ProcessStatus.success,
      ),
    );
    print('FILTERED PLANTS: ${state.plants}');
  }

  // searching for plants
  void setSearchedPlants({
    required String keyword,
  }) {
    List<Plant> searchedPlants;

    searchedPlants = state.plants
        .where((plant) =>
            plant.title.toLowerCase().contains(keyword) ||
            plant.description.toLowerCase().contains(keyword))
        .toList();
    print('THIS IS THE PLANT DETAILS: $searchedPlants');
    emit(
      state.copyWith(
        plants: searchedPlants,
        status: ProcessStatus.success,
      ),
    );
  }

  // filtering plants
  void setFilteredPlants({
    required PlantFilter plantFilter,
  }) {
    List<Plant> filteredPlants = [];

    switch (plantFilter) {
      case PlantFilter.name:
        filteredPlants = [...state.plants]
          ..sort((a, b) => a.title.compareTo(b.title));
        break;

      case PlantFilter.date:
        filteredPlants = [...state.plants]
          ..sort((a, b) => a.date.compareTo(b.date));
        break;
    }

    print('THIS IS THE PLANT DETAILS: $filteredPlants');
    emit(
      state.copyWith(
        plants: filteredPlants,
        status: ProcessStatus.success,
      ),
    );
  }
}
