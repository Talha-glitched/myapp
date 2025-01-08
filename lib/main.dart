import 'package:flutter/material.dart';
import './add_task_page.dart'; // Replace with the actual path to your AddTaskPage file
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that widgets are bound
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddTaskPage(), // The AddTaskPage widget
    );
  }
}
