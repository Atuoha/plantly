part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final PlantFilter plantFilter;
  final bool nameFilter;
  final bool dateFilter;

  const FilterState({
    required this.plantFilter,
    required this.nameFilter,
    required this.dateFilter,
  });

  factory FilterState.initial() => const FilterState(
        plantFilter: PlantFilter.none,
        nameFilter: false,
        dateFilter: false,
      );

  @override
  List<Object> get props => [
        plantFilter,
        nameFilter,
        dateFilter,
      ];

  @override
  String toString() {
    return 'FilterState{plantFilter: $plantFilter,nameFilter: $nameFilter,plantFilter:$dateFilter}';
  }

  FilterState copyWith({
    PlantFilter? plantFilter,
    bool? nameFilter,
    bool? dateFilter,
  }) {
    return FilterState(
      plantFilter: plantFilter ?? this.plantFilter,
      nameFilter: nameFilter ?? this.nameFilter,
      dateFilter: dateFilter ?? this.dateFilter,
    );
  }
}
