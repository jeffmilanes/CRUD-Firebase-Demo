import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:morphosis_flutter_demo/tasks/bloc/task_bloc.dart';
import 'package:morphosis_flutter_demo/tasks/model/task.dart';

class TaskPage extends StatelessWidget {
  TaskPage({this.task});

  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(task == null ? 'New Task' : 'Edit Task'),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return _TaskForm(task, constraints);
        }));
  }
}

class _TaskForm extends StatefulWidget {
  _TaskForm(this.task, this.constraints);

  final Task? task;
  final BoxConstraints constraints;
  @override
  __TaskFormState createState() => __TaskFormState(task);
}

class __TaskFormState extends State<_TaskForm> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const double _padding = 16;

  __TaskFormState(this.task);

  Task? task;
  TextEditingController? _titleController;
  TextEditingController? _descriptionController;

  void init() {
    if (task == null) {
      task = Task();
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
    } else {
      _titleController = TextEditingController(text: task?.title);
      _descriptionController = TextEditingController(text: task?.description);
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void _save(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      task!.isNew
          ? BlocProvider.of<TaskBloc>(context).add(AddTask(task!))
          : BlocProvider.of<TaskBloc>(context).add(EditTask(task!));
      EasyLoading.showSuccess(task!.isNew
          ? 'Successfully Added ${task!.title}'
          : 'Successfully Updated ${task!.title}');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(_padding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: widget.constraints.maxWidth,
              minHeight: widget.constraints.maxHeight - _padding),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    controller: _titleController,
                    onChanged: (val) => task!.title = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    validator: (val) {
                      return val!.trim().isEmpty ? 'Name required' : null;
                    },
                  ),
                  SizedBox(height: _padding),
                  TextField(
                    controller: _descriptionController,
                    onChanged: (val) => task!.description = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    minLines: 5,
                    maxLines: 10,
                  ),
                  SizedBox(height: _padding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Completed ?'),
                      CupertinoSwitch(
                        value: task!.isCompleted,
                        onChanged: (_) {
                          setState(() {
                            task!.toggleComplete();
                          });
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => _save(context),
                    child: Container(
                      width: double.infinity,
                      child: Center(
                          child: Text(task!.isNew ? 'Create' : 'Update')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
