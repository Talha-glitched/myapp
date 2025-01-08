import 'package:flutter/material.dart';
import './add_task_page.dart'; // Replace with the actual path to your AddTaskPage file

void main() {
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
