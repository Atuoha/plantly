import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/plant.dart';
import '../../repositories/plant_repository.dart';
import '../filter/filter_cubit.dart';
import '../search_plant/search_cubit.dart';

part 'filtered_plants_state.dart';

class FilteredPlantsCubit extends Cubit<FilteredPlantsState> {
  final PlantRepository plantRepository;
  final FilterCubit filterCubit;
  final SearchCubit searchCubit;
  late StreamSubscription filterSubscription;
  late StreamSubscription searchSubscription;

  FilteredPlantsCubit({
    required this.filterCubit,
    required this.searchCubit,
    required this.plantRepository,
  }) : super(FilteredPlantsState.initial()) {
    // listening to search cubit
    filterSubscription = searchCubit.stream.listen((searchState) async {
      List<Plant> plants =
          await plantRepository.fetchSearchPlants(searchState.keyword);
      emit(state.copyWith(plants: plants));
    });

    // listening to filter cubit
    filterSubscription = filterCubit.stream.listen((filterState) async {
      List<Plant> plants =
          await plantRepository.fetchFilteredPlants(filterState.plantFilter);
      emit(state.copyWith(plants: plants));
    });
  }
}
