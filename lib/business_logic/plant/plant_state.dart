part of 'plant_cubit.dart';

class PlantState extends Equatable {
  final ProcessStatus status;
  final CustomError error;
  final Plant plant;

  const PlantState({
    required this.plant,
    required this.error,
    required this.status,
  });

  factory PlantState.initial() => PlantState(
        plant: Plant.initial(),
        error: CustomError.initial(),
        status: ProcessStatus.initial,
      );

  @override
  List<Object> get props => [status, error, plant];

  @override
  String toString() {
    return 'PlantState{status: $status, error: $error, plant: $plant}';
  }

  PlantState copyWith({
    ProcessStatus? status,
    CustomError? error,
    Plant? plant,
  }) {
    return PlantState(
      status: status ?? this.status,
      error: error ?? this.error,
      plant: plant ?? this.plant,
    );
  }
}


