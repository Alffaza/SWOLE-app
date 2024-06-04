import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swole_app/firebase_options.dart';
import 'package:swole_app/pages/create_routine.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({Key? key}) : super(key: key);

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Routine',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            color: Colors.amber[800],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        elevation:  0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateRoutinePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
