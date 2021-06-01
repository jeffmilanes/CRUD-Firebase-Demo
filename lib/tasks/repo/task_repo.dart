import 'dart:async';
import 'package:morphosis_flutter_demo/tasks/model/task.dart';

abstract class TaskRepo {
  Future<void> addTask(Task task);

  Future<void> editTask(Task task);

  Stream<List<Task>> tasks();

  Future<void> deleteTask(Task task);
}
