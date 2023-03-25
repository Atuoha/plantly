part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final PlantFilter plantFilter;
  const FilterState({required this.plantFilter});

  factory FilterState.initial() =>
      const FilterState(plantFilter: PlantFilter.none);

  @override
  List<Object> get props => [plantFilter];

  @override
  String toString() {
    return 'FilterState{plantFilter: $plantFilter}';
  }

  FilterState copyWith({
    PlantFilter? plantFilter,
  }) {
    return FilterState(
      plantFilter: plantFilter ?? this.plantFilter,
    );
  }
}
