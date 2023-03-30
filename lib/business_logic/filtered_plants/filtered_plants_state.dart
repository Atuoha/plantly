part of 'filtered_plants_cubit.dart';

class FilteredPlantsState extends Equatable {
  final List<Plant> plants;
  final ProcessStatus status;

  const FilteredPlantsState({required this.plants, required this.status});

  factory FilteredPlantsState.initial()=>
      const FilteredPlantsState(plants: [], status: ProcessStatus.initial,);

  @override
  List<Object> get props => [plants, status];

  @override
  String toString() {
    return 'FilteredPlantsState{plants: $plants, status: $status}';
  }

  FilteredPlantsState copyWith({
    List<Plant>? plants,
    ProcessStatus? status,
  }) {
    return FilteredPlantsState(
      plants: plants ?? this.plants,
      status: status ?? this.status,
    );
  }
}


