part of 'task_cubit.dart';

class TaskState extends Equatable {
  final ProcessStatus status;
  final CustomError error;
  final Task task;

  const TaskState({
    required this.task,
    required this.error,
    required this.status,
  });

  factory TaskState.initial() => TaskState(
        task: Task.initial(),
        error: CustomError.initial(),
        status: ProcessStatus.initial,
      );

  @override
  List<Object> get props => [status, error, task];

  @override
  String toString() {
    return 'PlantState{status: $status, error: $error, task: $task}';
  }

  TaskState copyWith({
    ProcessStatus? status,
    CustomError? error,
    Task? task,
  }) {
    return TaskState(
      status: status ?? this.status,
      error: error ?? this.error,
      task: task ?? this.task,
    );
  }
}
