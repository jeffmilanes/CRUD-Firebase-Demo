import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:morphosis_flutter_demo/main/widget/error.dart';
import 'package:morphosis_flutter_demo/tasks/bloc/task_bloc.dart';
import 'package:morphosis_flutter_demo/tasks/model/task.dart';
import 'package:morphosis_flutter_demo/tasks/view/task.dart';

class TaskListsPage extends StatefulWidget {
  const TaskListsPage({required this.title, required this.all});

  final String title;
  final bool all;

  @override
  _TaskListsPageState createState() => _TaskListsPageState();
}

class _TaskListsPageState extends State<TaskListsPage> {
  @override
  void initState() {
    super.initState();
  }

  void addTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => addTask(context),
          )
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TasksLoaded) {
            if (state.tasks.isEmpty) {
              return Center(
                child: Text('Task(s) not found'),
              );
            }

            var task = state.tasks;
            if (!widget.all)
              task =
                  task.where((element) => element.completedAt != null).toList();
            return ListView.builder(
                itemCount: task.length,
                itemBuilder: (context, index) {
                  return _Task(task[index]);
                });
          }

          if (state is TasksError) {
            return ErrorMessage(
              message: 'Data cannot fetch',
              buttonTitle: 'Refresh',
              onTap: () => context.read<TaskBloc>()..add(LoadTasks()),
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _Task extends StatelessWidget {
  _Task(this.task);

  final Task task;

  void _delete(BuildContext context) {
    BlocProvider.of<TaskBloc>(context).add(DeleteTask(task));
    EasyLoading.showSuccess('Successfully Deleted ${task.title}');
  }

  void _toggleComplete(BuildContext context) {
    task.toggleComplete();
    BlocProvider.of<TaskBloc>(context).add(EditTask(task));
  }

  void _view(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskPage(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: Icon(
          task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
        ),
        onPressed: () => _toggleComplete(context),
      ),
      title: Text(task.title ?? ''),
      subtitle: Text(task.description ?? ''),
      trailing: IconButton(
          icon: Icon(
            Icons.delete,
          ),
          onPressed: () => _delete(context)),
      onTap: () => _view(context),
    );
  }
}
