part of 'task_cubit.dart';

class TaskState extends Equatable {
  final ProcessStatus status;
  final CustomError error;
  final Task task;
  final List<Task> tasks;

  const TaskState({
    required this.task,
    required this.error,
    required this.status,
    required this.tasks,
  });

  factory TaskState.initial() => TaskState(
        task: Task.initial(),
        error: CustomError.initial(),
        status: ProcessStatus.initial,
        tasks: const [],
      );

  @override
  List<Object> get props => [status, error, task, tasks];

  @override
  String toString() {
    return 'PlantState{status: $status, error: $error, task: $task, tasks: $tasks}';
  }

  TaskState copyWith({
    ProcessStatus? status,
    CustomError? error,
    Task? task,
    List<Task>? tasks,
  }) {
    return TaskState(
      status: status ?? this.status,
      error: error ?? this.error,
      task: task ?? this.task,
      tasks: tasks ?? this.tasks,
    );
  }
}
