import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:morphosis_flutter_demo/tasks/model/task.dart';
import 'package:morphosis_flutter_demo/tasks/repo/task_repo.dart';

class FirebaseManager extends TaskRepo {
  CollectionReference get tasksRef =>
      FirebaseFirestore.instance.collection('jeffmilanes');

  @override
  Stream<List<Task>> tasks() {
    return tasksRef.snapshots().map((snapshot) => snapshot.docs.map((e) {
          Map<String, dynamic> data = {
            'id': e.id,
            'title': e['title'],
            'description': e['description'],
            'completed_at': e['completed_at']
          };
          return Task.fromJson(data);
        }).toList());
  }

  @override
  Future<void> addTask(Task task) async {
    tasksRef
        .add(task.toJson())
        .then((value) => print('Task Added'))
        .catchError((error) => print('Failed to Add Task: $error'));
  }

  @override
  Future<void> editTask(Task task) async {
    tasksRef
        .doc(task.id)
        .update(task.toJson())
        .then((value) => print('Task Updated'))
        .catchError((error) => print('Failed to Update Task: $error'));
  }

  @override
  Future<void> deleteTask(Task task) async {
    tasksRef
        .doc(task.id)
        .delete()
        .then((value) => print('Task Deleted'))
        .catchError((error) => print('Failed to Delete Task: $error'));
  }
}
