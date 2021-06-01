import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:morphosis_flutter_demo/bloc_observer.dart';
import 'package:morphosis_flutter_demo/home/bloc/team_bloc.dart';
import 'package:morphosis_flutter_demo/home/repo/team_repo.dart';
import 'package:morphosis_flutter_demo/main/widget/error.dart';
import 'package:morphosis_flutter_demo/main/view/index.dart';
import 'package:morphosis_flutter_demo/tasks/bloc/task_bloc.dart';
import 'package:morphosis_flutter_demo/tasks/repo/firebase_manager.dart';

const title = 'Morphosis Demo';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runZonedGuarded(() {
    runApp(FirebaseApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
  });
}

class FirebaseApp extends StatefulWidget {
  @override
  _FirebaseAppState createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    debugPrint("firebase initialized");

    // Pass all uncaught errors to Crashlytics.
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      // Forward to original handler.
      originalOnError!(errorDetails);
    };
  }

  // Define an async function to initialize FlutterFire
  void initialize() async {
    if (_error) {
      setState(() {
        _error = false;
      });
    }

    try {
      await _initializeFlutterFire();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error || !_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: Scaffold(
          body: _error
              ? ErrorMessage(
                  message: "Problem initialising the app",
                  buttonTitle: "RETRY",
                  onTap: initialize,
                )
              : Container(),
        ),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider<TeamBloc>(
          create: (_) => TeamBloc(teamRepo: TeamRepo())..add(Fetch()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) =>
              TaskBloc(taskRepo: FirebaseManager())..add(LoadTasks()),
        )
      ],
      child: App(),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: IndexPage(),
      builder: EasyLoading.init(),
    );
  }
}
