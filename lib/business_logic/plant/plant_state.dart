part of 'plant_cubit.dart';

class PlantState extends Equatable {
  final ProcessStatus status;
  final CustomError error;
  final Plant plant;
  final int tasks;
  final List<Plant> plants;

  const PlantState({
    required this.plant,
    required this.error,
    required this.status,
    required this.tasks,
    required this.plants,
  });

  factory PlantState.initial() => PlantState(
        plant: Plant.initial(),
        error: CustomError.initial(),
        status: ProcessStatus.initial,
        tasks: 0,
        plants: const [],
      );

  @override
  List<Object> get props => [status, error, plant, tasks, plants];

  @override
  String toString() {
    return 'PlantState{status: $status, error: $error, plant: $plant,tasks:$tasks, plants: $plants}';
  }

  PlantState copyWith({
    ProcessStatus? status,
    CustomError? error,
    Plant? plant,
    int? tasks,
    List<Plant>? plants,
  }) {
    return PlantState(
      status: status ?? this.status,
      error: error ?? this.error,
      plant: plant ?? this.plant,
      tasks: tasks ?? this.tasks,
      plants: plants ?? this.plants,
    );
  }
}
