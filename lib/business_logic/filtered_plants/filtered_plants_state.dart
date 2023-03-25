part of 'filtered_plants_cubit.dart';

class FilteredPlantsState extends Equatable {
  final List<Plant> plants;
  const FilteredPlantsState({required this.plants});

  factory FilteredPlantsState.initial()=>const FilteredPlantsState(plants: []);

  @override
  List<Object> get props => [plants];

  @override
  String toString() {
    return 'FilteredPlantsState{plants: $plants}';
  }

  FilteredPlantsState copyWith({
    List<Plant>? plants,
  }) {
    return FilteredPlantsState(
      plants: plants ?? this.plants,
    );
  }
}


