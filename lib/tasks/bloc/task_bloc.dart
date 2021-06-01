import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:morphosis_flutter_demo/tasks/model/task.dart';
import 'package:morphosis_flutter_demo/tasks/repo/task_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({required this.taskRepo}) : super(TaskInitial());

  final TaskRepo taskRepo;
  StreamSubscription? _tasksSubscription;

  @override
  Stream<TaskState> mapEventToState(
    TaskEvent event,
  ) async* {
    if (event is LoadTasks) {
      yield* _mapLoadTodosToState(event);
    } else if (event is ToggleTasks) {
      yield* _mapToggleTasksToState(event);
    } else if (event is AddTask) {
      yield* _mapAddTaskToState(event);
    } else if (event is EditTask) {
      yield* _mapEditTaskToState(event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(event);
    } else if (event is TaskUpdate) {
      yield* _mapTaskUpdateToState(event);
    }
  }

  Stream<TaskState> _mapLoadTodosToState(LoadTasks event) async* {
    _tasksSubscription?.cancel();
    _tasksSubscription = taskRepo.tasks().listen((todos) {
      add(TaskUpdate(todos));
    });
  }

  Stream<TaskState> _mapToggleTasksToState(ToggleTasks event) async* {
    if (state is TasksLoaded) {
      final List<Task> updatedTasks = (state as TasksLoaded)
          .tasks
          .where((e) => e.completedAt != null)
          .toList();

      yield TasksLoaded(tasks: updatedTasks);
    }
  }

  Stream<TaskState> _mapEditTaskToState(EditTask event) async* {
    taskRepo.editTask(event.task);
  }

  Stream<TaskState> _mapDeleteTaskToState(DeleteTask event) async* {
    taskRepo.deleteTask(event.task);
  }

  Stream<TaskState> _mapTaskUpdateToState(TaskUpdate event) async* {
    try {
      yield TasksLoaded(tasks: event.tasks);
    } on Exception {
      yield TasksError('Error');
    }
  }

  Stream<TaskState> _mapAddTaskToState(AddTask event) async* {
    taskRepo.addTask(event.task);
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
