import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../constants/enums/plant_filter.dart';
import '../../models/plant.dart';

part 'filtered_plants_state.dart';

class FilteredPlantsCubit extends Cubit<FilteredPlantsState> {
  final List<Plant> plants;

  FilteredPlantsCubit({required this.plants})
      : super(FilteredPlantsState(plants: plants));

  // searching for plants
  void setSearchedPlants({
    required List<Plant> plants,
    required String keyword,
  }) {
    List<Plant> searchedPlants;

    searchedPlants = plants
        .where((plant) =>
    plant.title.toLowerCase().contains(keyword) ||
        plant.description.toLowerCase().contains(keyword))
        .toList();
    print('THIS IS THE PLANT DETAILS: $searchedPlants');
    emit(state.copyWith(plants: searchedPlants));
  }

  // filtering plants
  void setFilteredPlants({
    required List<Plant> plants,
    required PlantFilter plantFilter,
  }) {
    List<Plant> filteredPlants = [];

    switch (plantFilter) {
      case PlantFilter.name:
        filteredPlants = [...plants]
          ..sort((a, b) => a.title.compareTo(b.title));
        break;

      case PlantFilter.date:
        filteredPlants = [...plants]..sort((a, b) => a.date.compareTo(b.date));
        break;
    }

    print('THIS IS THE PLANT DETAILS: $filteredPlants');
    emit(state.copyWith(plants: filteredPlants));
  }
}
