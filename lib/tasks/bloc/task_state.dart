part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TasksLoaded extends TaskState {
  const TasksLoaded({required this.tasks});

  final List<Task> tasks;

  @override
  List<Object> get props => [tasks];

  @override
  String toString() {
    return 'TasksLoaded { Tasks: $tasks }';
  }
}

class TasksError extends TaskState {
  const TasksError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
