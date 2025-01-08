import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;

  // Function to pick a date
  Future<void> _pickDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  // Function to add task to Firestore
  Future<void> _addTaskToFirestore() async {
    if (_formKey.currentState!.validate() && _selectedDueDate != null) {
      try {
        // Adding the task to Firestore
        await FirebaseFirestore.instance.collection('tasks').add({
          'taskName': _taskNameController.text,
          'description': _descriptionController.text,
          'dueDate': _selectedDueDate!.toIso8601String(),
        });

        // Show success message and clear form
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully!')),
        );
        _taskNameController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedDueDate = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Task Name Input
              TextFormField(
                controller: _taskNameController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDueDate == null
                          ? 'No due date selected'
                          : 'Due Date: ${_selectedDueDate!.toLocal()}'.split(' ')[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickDueDate,
                    child: const Text('Pick Due Date'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Add Task Button
              ElevatedButton(
                onPressed: _addTaskToFirestore,
                child: const Text('Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
