part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class ToggleTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  const AddTask(this.task);

  final Task task;

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'AddTask { task: $task }';
}

class DeleteTask extends TaskEvent {
  const DeleteTask(this.task);

  final Task task;

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'DeleteTask { todo: $task }';
}

class EditTask extends TaskEvent {
  const EditTask(this.task);

  final Task task;

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'EditTask { todo: $task }';
}

class TaskUpdate extends TaskEvent {
  const TaskUpdate(this.tasks);

  final List<Task> tasks;

  @override
  List<Object> get props => [tasks];
}
