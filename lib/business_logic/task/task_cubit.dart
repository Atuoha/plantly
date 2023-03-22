import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../constants/enums/process_status.dart';
import '../../models/custom_error.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository taskRepository;

  TaskCubit({required this.taskRepository}) : super(TaskState.initial());

  Future<void> addTask({required Task task}) async {
    emit(state.copyWith(status: ProcessStatus.loading));

    try {
      await taskRepository.addTask(task: task);
      emit(state.copyWith(
        task: task,
        status: ProcessStatus.success,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: ProcessStatus.error,
        error: e,
      ));
    }
  }

  Future<void> editTask({
    required Task task,
    required String id,
  }) async {
    emit(state.copyWith(status: ProcessStatus.loading));

    try {
      await taskRepository.editTask(task: task, id: id);
      emit(state.copyWith(
        task: task,
        status: ProcessStatus.success,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: ProcessStatus.error,
        error: e,
      ));
    }
  }

    Future<void> deleteTask({required String id}) async {
      emit(state.copyWith(status: ProcessStatus.loading));
      try {
        await taskRepository.deleteTask(id: id);
        emit(state.copyWith(
          status: ProcessStatus.success,
        ));
      } on CustomError catch (e) {
        emit(state.copyWith(
          status: ProcessStatus.error,
          error: e,
        ));
      }
    }
  }

